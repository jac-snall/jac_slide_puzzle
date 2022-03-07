import 'dart:developer' as dev;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:jac_slide_puzzle/puzzle/cubit/puzzle_cubit.dart';

class AnimatedPuzzleCube extends StatefulWidget {
  const AnimatedPuzzleCube({Key? key}) : super(key: key);

  @override
  _AnimatedPuzzleCubeState createState() => _AnimatedPuzzleCubeState();
}

class _AnimatedPuzzleCubeState extends State<AnimatedPuzzleCube>
    with SingleTickerProviderStateMixin {
  // Should be in bloc instead...
  // A small skew to the cube. Makes the top and side slightly visible
  Matrix4 transformation = Matrix4.identity()
    ..rotateX(pi / 16)
    ..rotateY(pi / 16);

  //Animation objects
  late AnimationController controller;
  late Animation<Matrix4> animation;
  RotationTween rotationTween = RotationTween();

  @override
  void initState() {
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    rotationTween.begin = transformation;
    rotationTween.end = transformation;
    animation = rotationTween.animate(controller);
    super.initState();
  }

  void startAnimation(BuildContext context, PuzzleState state) {
    dev.log('Animate rotation');
    rotationTween.begin = rotationTween.end;
    rotationTween.end = state.skew.multiplied(state.transformation);
    controller.reset();
    controller.forward();
  }

  final List<Side> sides = [
    const Side(color: Colors.blue, name: "front", index: 0), // Front
    const Side(color: Colors.green, name: "back", index: 1), // Back
    const Side(color: Colors.yellow, name: "left", index: 2), // Left
    const Side(color: Colors.red, name: "Right", index: 3), // Right
    const Side(color: Colors.pink, name: "Top", index: 4), // Top
    const Side(color: Colors.grey, name: "Bottom", index: 5), // Bottom
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<PuzzleCubit, PuzzleState>(
      listenWhen: (previous, current) {
        var change = previous.transformation != current.transformation;
        dev.log(change.toString());
        return change;
      },
      listener: startAnimation,
      child: Flow(
        delegate: CubeFlowDelegate(cubeAnimation: animation),
        children: sides,
      ),
    );
  }
}

class CubeFlowDelegate extends FlowDelegate {
  final Animation<Matrix4> cubeAnimation;

  List<Matrix4> sideRot = [
    Matrix4.identity()
      ..rotateX(0)
      ..rotateY(0)
      ..translate(0.0, 0.0, -150.0),
    Matrix4.identity()
      ..rotateX(pi)
      ..rotateY(0)
      ..translate(0.0, 0.0, -150.0),
    Matrix4.identity()
      ..rotateX(0)
      ..rotateY(pi / 2)
      ..translate(0.0, 0.0, -150.0),
    Matrix4.identity()
      ..rotateX(0)
      ..rotateY(-pi / 2)
      ..translate(0.0, 0.0, -150.0),
    Matrix4.identity()
      ..rotateX(-pi / 2)
      ..rotateY(0)
      ..translate(0.0, 0.0, -150.0),
    Matrix4.identity()
      ..rotateX(pi / 2)
      ..rotateY(0)
      ..translate(0.0, 0.0, -150.0),
  ];

  CubeFlowDelegate({required this.cubeAnimation})
      : super(repaint: cubeAnimation);

  bool isVisible(int side, Matrix4 transformation) {
    var midpoint = vector.Vector3(0, 0, -1.0)..applyMatrix4(transformation);
    return midpoint.z < 0;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // Need to translate -150,-150 first to get center of child to rotate around origo
    // Then translate 250, 250 to get to the center of the flow

    for (int i = 0; i < context.childCount; i++) {
      Matrix4 transformation = cubeAnimation.value.multiplied(sideRot[i]);
      if (isVisible(i, transformation)) {
        context.paintChild(
          i,
          transform: Matrix4.translationValues(250, 250, 0)
              .multiplied(transformation)
              .multiplied(Matrix4.translationValues(-150, -150, 0)),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CubeFlowDelegate oldDelegate) {
    return cubeAnimation != oldDelegate.cubeAnimation;
  }
}

class Side extends StatelessWidget {
  final Color color;
  final String name;
  final int index;

  const Side({
    Key? key,
    required this.color,
    required this.name,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var puzzle = context.select((PuzzleCubit bloc) => bloc.state.puzzle);
    var colors = context.select((PuzzleCubit bloc) => bloc.state.sideColors);
    var tiles = puzzle.sides[index].tiles;
    dev.log('${puzzle.getWhiteSpaceNeighbours()}');
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        children: [
          for (var tile in tiles)
            AnimatedPositioned(
              key: ValueKey('${tile.correctPosition}'),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              left: 300.0 / puzzle.size * (tile.currentPosition.x),
              top: 300.0 / puzzle.size * (tile.currentPosition.y),
              child: SizedBox(
                width: 300.0 / puzzle.size,
                height: 300.0 / puzzle.size,
                child: GestureDetector(
                  onTap: () => context.read<PuzzleCubit>().tileTapped(tile),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: tile.isWhiteSpace
                          ? Colors.transparent
                          : colors[tile.correctPosition.side],
                    ),
                    child: Center(
                      child: Text(
                        '${tile.currentPosition}\n${tile.correctPosition}\n${tile.isWhiteSpace}',
                        //'${tile.correctPosition.y * puzzle.size + tile.correctPosition.x + 1}',
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class RotationTween extends Tween<Matrix4> {
  @override
  Matrix4 lerp(double t) {
    assert(begin != null);
    assert(end != null);

    //slerp for interpolating between rotations
    // see stack overflow: https://stackoverflow.com/a/4099423

    vector.Quaternion qa = vector.Quaternion.fromRotation(begin!.getRotation())
      ..normalize();
    vector.Quaternion qb = vector.Quaternion.fromRotation(end!.getRotation())
      ..normalize();

    double cosHalfTheta = qa.w * qb.w + qa.x * qb.x + qa.y * qb.y + qa.z * qb.z;

    if (cosHalfTheta < 0) {
      qb.scale(-1);
      cosHalfTheta = -cosHalfTheta;
    }

    if (cosHalfTheta >= 1.0) {
      return Matrix4.compose(
          vector.Vector3.zero(), qa, vector.Vector3(1, 1, 1));
    }

    double halfTheta = acos(cosHalfTheta);
    double sinHalfTheta = sqrt(1.0 - cosHalfTheta * cosHalfTheta);

    if (sinHalfTheta.abs() < 0.001) {
      return Matrix4.compose(
          vector.Vector3.zero(),
          vector.Quaternion(
            (qa.x + qb.x) / 2,
            (qa.y + qb.y) / 2,
            (qa.z + qb.z) / 2,
            (qa.w + qb.w) / 2,
          ),
          vector.Vector3.zero());
    }

    double ratioA = sin((1 - t) * halfTheta) / sinHalfTheta;
    double ratioB = sin(t * halfTheta) / sinHalfTheta;

    return Matrix4.compose(
        vector.Vector3.zero(),
        vector.Quaternion(
          qa.x * ratioA + qb.x * ratioB,
          qa.y * ratioA + qb.y * ratioB,
          qa.z * ratioA + qb.z * ratioB,
          qa.w * ratioA + qb.w * ratioB,
        ),
        vector.Vector3(1, 1, 1));
  }
}
