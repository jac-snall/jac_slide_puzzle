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
    rotationTween.begin = rotationTween.end;
    rotationTween.end = state.skew.multiplied(state.transformation);
    controller.reset();
    controller.forward();
  }

  final List<Side> sides = [
    Side(color: Colors.blue, rotX: 0, rotY: 0, name: "front"), // Front
    Side(color: Colors.green, rotX: pi, rotY: 0, name: "back"), // Back
    Side(color: Colors.yellow, rotX: 0, rotY: pi / 2, name: "left"), // Left
    Side(color: Colors.red, rotX: 0, rotY: -pi / 2, name: "Right"), // Right
    Side(color: Colors.pink, rotX: -pi / 2, rotY: 0, name: "Top"), // Top
    Side(color: Colors.grey, rotX: pi / 2, rotY: 0, name: "Bottom"), // Bottom
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<PuzzleCubit, PuzzleState>(
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
    /*var midPointCopy = midPoints[side].clone();
    midPointCopy.applyMatrix4(transformation);
    return midPointCopy.z < 0;*/
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
  final double rotX, rotY;
  final String name;

  //Tiles
  final List<int> tiles = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
  ];

  Side({
    Key? key,
    required this.color,
    required this.rotX,
    required this.rotY,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        children: [
          for (var item in tiles)
            Positioned(
              left: 100.0 * (item % 3),
              top: 100.0 * (item ~/ 3),
              child: SizedBox(
                width: 100,
                height: 100,
                child: GestureDetector(
                  onTap: () => dev.log('Side: $name, tile: ${item + 1}'),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 5),
                      color: color,
                    ),
                    child: Center(
                      child: Text('${item + 1} '),
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
