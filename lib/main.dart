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
  double _x = pi / 4, _y = pi / 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GestureDetector(
        onPanUpdate: (DragUpdateDetails u) => setState(() {
          _x = (_x + u.delta.dy / 150) % (pi * 2);
          _y = (_y + -u.delta.dx / 150) % (pi * 2);
        }),
        child: SizedBox(
          width: 400,
          height: 400,
          child: Center(child: Cube(rotX: _x, rotY: _y)),
        ),
      ),
    );
  }
}

class Cube extends StatelessWidget {
  final double rotX, rotY;
  Cube({Key? key, required this.rotX, required this.rotY}) : super(key: key);
  final List<Side> sides = [
    Side(
      color: Colors.blue,
      rotX: 0,
      rotY: 0,
      name: "front",
    ), // Front
    Side(
      color: Colors.green,
      rotX: pi,
      rotY: 0,
      name: "back",
    ), // Back
    Side(
      color: Colors.yellow,
      rotX: 0,
      rotY: pi / 2,
      name: "left",
    ), // Left
    Side(color: Colors.red, rotX: 0, rotY: 3 * pi / 2, name: "Right"), // Right
    Side(
      color: Colors.pink,
      rotX: 3 * pi / 2,
      rotY: 0,
      name: "Top",
    ), // Top
    Side(
      color: Colors.grey,
      rotX: pi / 2,
      rotY: 0,
      name: "Bottom",
    ), // Bottom
  ];
  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..rotateX(rotX)
        ..rotateY(rotY),
      alignment: Alignment.center,
      child: Stack(
        children: sides
            .where(
              (side) => side.visible(rotX, rotY),
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

  bool visible(double rotX, double rotY) {
    var midPointCopy = midPoint.clone();
    midPointCopy.applyMatrix4(Matrix4.identity()
      ..rotateX(rotX)
      ..rotateY(rotY));
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
        ..translate(0.0, 0.0, -50.0),
      alignment: Alignment.center,
      child: Container(
        width: 100,
        height: 100,
        color: widget.color,
        child: const Center(
          child: Icon(Icons.arrow_upward),
        ),
      ),
    );
  }
}
