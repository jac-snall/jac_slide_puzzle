import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vec;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        //scaffoldBackgroundColor: Colors.black,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Matrix4 skew = Matrix4.identity()
    ..rotateX(pi / 16)
    ..rotateY(pi / 16);
  Matrix4 transformation = Matrix4.identity();

  //Animation objects
  late AnimationController controller;
  RotationTween rotTween = RotationTween();
  late Animation<Matrix4> animation;

  @override
  void initState() {
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);

    //Current transformation
    rotTween.begin = skew.multiplied(transformation);
    rotTween.end = skew.multiplied(transformation);
    animation = rotTween.animate(controller)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  void updateView(Matrix4 trans) {
    if (!controller.isAnimating) {
      transformation = trans..multiply(transformation);
      rotTween.begin = rotTween.end;
      rotTween.end = skew.multiplied(transformation);
      controller.reset();
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                updateView(Matrix4.rotationX(-pi / 2));
              },
              icon: const Icon(Icons.arrow_upward),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    updateView(Matrix4.rotationY(pi / 2));
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                SizedBox(
                  width: 500,
                  height: 500,
                  child: Center(
                    child: Cube(
                      transformation: animation.value,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    updateView(Matrix4.rotationY(-pi / 2));
                  },
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                updateView(Matrix4.rotationX(pi / 2));
              },
              icon: const Icon(Icons.arrow_downward),
            ),
          ],
        ),
      ),
    );
  }
}

class Cube extends StatelessWidget {
  //final double rotX, rotY;
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

class Side extends StatefulWidget {
  final Color color;
  final double rotX, rotY;
  final String name;

  final vec.Vector3 midPoint = vec.Vector3(0.0, 0.0, -1.0);

  Side(
      {Key? key,
      required this.color,
      required this.rotX,
      required this.rotY,
      required this.name})
      : super(key: key) {
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
  _SideState createState() => _SideState();
}

class _SideState extends State<Side> {
  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..rotateX(widget.rotX)
        ..rotateY(widget.rotY)
        ..translate(0.0, 0.0, -150.0),
      alignment: Alignment.center,
      child: SizedBox(
        width: 300,
        height: 300,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: widget.color,
            ),
            child: const Center(
              child: Icon(Icons.arrow_upward),
            ),
          ),
        ),
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

    vec.Quaternion qa = vec.Quaternion.fromRotation(begin!.getRotation())
      ..normalize();
    vec.Quaternion qb = vec.Quaternion.fromRotation(end!.getRotation())
      ..normalize();

    double cosHalfTheta = qa.w * qb.w + qa.x * qb.x + qa.y * qb.y + qa.z * qb.z;

    if (cosHalfTheta < 0) {
      qb.scale(-1);
      cosHalfTheta = -cosHalfTheta;
    }

    if (cosHalfTheta >= 1.0) {
      return Matrix4.compose(vec.Vector3.zero(), qa, vec.Vector3(1, 1, 1));
    }

    double halfTheta = acos(cosHalfTheta);
    double sinHalfTheta = sqrt(1.0 - cosHalfTheta * cosHalfTheta);

    if (sinHalfTheta.abs() < 0.001) {
      return Matrix4.compose(
          vec.Vector3.zero(),
          vec.Quaternion(
            (qa.x + qb.x) / 2,
            (qa.y + qb.y) / 2,
            (qa.z + qb.z) / 2,
            (qa.w + qb.w) / 2,
          ),
          vec.Vector3.zero());
    }

    double ratioA = sin((1 - t) * halfTheta) / sinHalfTheta;
    double ratioB = sin(t * halfTheta) / sinHalfTheta;

    return Matrix4.compose(
        vec.Vector3.zero(),
        vec.Quaternion(
          qa.x * ratioA + qb.x * ratioB,
          qa.y * ratioA + qb.y * ratioB,
          qa.z * ratioA + qb.z * ratioB,
          qa.w * ratioA + qb.w * ratioB,
        ),
        vec.Vector3(1, 1, 1));
  }
}
