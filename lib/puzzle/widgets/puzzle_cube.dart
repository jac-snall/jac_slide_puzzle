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
    animation = rotationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  void startAnimation(BuildContext context, PuzzleState state) {
    rotationTween.begin = rotationTween.end;
    rotationTween.end = state.skew.multiplied(state.transformation);
    controller.reset();
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PuzzleCubit, PuzzleState>(
      listener: startAnimation,
      child: Cube(
        transformation: animation.value,
      ),
    );
  }
}

class Cube extends StatelessWidget {
  final Matrix4 transformation;
  Cube({Key? key, required this.transformation}) : super(key: key);
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
    return Transform(
      transform: transformation,
      alignment: Alignment.center,
      child: Stack(
        children: sides
            .where(
              (side) => side.visible(transformation),
            )
            .toList(),
      ),
    );
  }
}

class Side extends StatelessWidget {
  final Color color;
  final double rotX, rotY;
  final String name;

//Midpoint of side
  final vector.Vector3 midPoint = vector.Vector3(0.0, 0.0, -1.0);

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
    10,
    11,
    12,
    13,
    14,
    15,
  ];

  Side({
    Key? key,
    required this.color,
    required this.rotX,
    required this.rotY,
    required this.name,
  }) : super(key: key) {
    midPoint.applyMatrix4(Matrix4.identity()
      ..rotateX(rotX)
      ..rotateY(rotY));
  }

  bool visible(Matrix4 transformation) {
    var midPointCopy = midPoint.clone();
    midPointCopy.applyMatrix4(transformation);
    return midPointCopy.z < 0;
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..rotateX(rotX)
        ..rotateY(rotY)
        ..translate(0.0, 0.0, -150.0),
      alignment: Alignment.center,
      child: SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          children: [
            for (var item in tiles)
              Positioned(
                left: 75.0 * (item % 4),
                top: 75.0 * (item ~/ 4),
                child: SizedBox(
                  width: 75,
                  height: 75,
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
            Positioned(
                child: SizedBox(
              width: 75,
              height: 75,
              child: Container(
                  decoration: BoxDecoration(
                border: Border.all(
                  width: 5,
                  color: Colors.yellow,
                ),
              )),
            ))
          ],
        ),
        /*Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: color),
            child: const Center(
              child: Icon(Icons.arrow_upward),
            ),
          ),
        ),*/
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
