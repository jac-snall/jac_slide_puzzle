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

class _MyHomePageState extends State<MyHomePage> {
  double _x = 0, _y = 0;
  Matrix4 skew = Matrix4.identity()
    ..rotateX(pi / 16)
    ..rotateY(pi / 16);
  late Matrix4 transformation;

  @override
  void initState() {
    transformation = Matrix4.identity()
      ..rotateX(_x)
      ..rotateY(_y);
    super.initState();
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
              onPressed: () => setState(() {
                _x = _x - pi / 2;
                transformation = Matrix4.identity()
                  ..rotateX(_x)
                  ..rotateY(_y);
              }),
              icon: const Icon(Icons.arrow_upward),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => setState(() {
                    _y = _y + pi / 2;
                    transformation = Matrix4.identity()
                      ..rotateY(_y)
                      ..rotateX(_x);
                  }),
                  icon: const Icon(Icons.arrow_back),
                ),
                SizedBox(
                  width: 500,
                  height: 500,
                  child: Center(
                    child: Cube(
                      transformation: skew.multiplied(transformation),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() {
                    _y = _y - pi / 2;
                    transformation = Matrix4.identity()
                      ..rotateY(_y)
                      ..rotateX(_x);
                  }),
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
            IconButton(
              onPressed: () => setState(() {
                _x = _x + pi / 2;
                transformation = Matrix4.identity()
                  ..rotateX(_x)
                  ..rotateY(_y);
              }),
              icon: const Icon(Icons.arrow_downward),
            ),
          ],
        ),
      ),
      /*body: GestureDetector(
        onPanUpdate: (DragUpdateDetails u) => setState(() {
          _x = (_x + u.delta.dy / 150) % (pi * 2);
          _y = (_y + -u.delta.dx / 150) % (pi * 2);
        }),
        child: Center(
          child: SizedBox(
            width: 600,
            height: 600,
            child: Center(child: Cube(rotX: _x, rotY: _y)),
          ),
        ),
      ),*/
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
