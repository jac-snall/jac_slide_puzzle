import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

part 'puzzle_state.dart';

class PuzzleCubit extends Cubit<PuzzleState> {
  PuzzleCubit()
      : super(
          PuzzleState(transformation: Matrix4.identity()),
        );

  void rotateLeft() {
    emit(PuzzleState(
        transformation: Matrix4.rotationY(pi / 2)
          ..multiply(state.transformation)));
  }

  void rotateRight() {
    emit(PuzzleState(
        transformation: Matrix4.rotationY(-pi / 2)
          ..multiply(state.transformation)));
  }

  void rotateUp() {
    emit(PuzzleState(
        transformation: Matrix4.rotationX(-pi / 2)
          ..multiply(state.transformation)));
  }

  void rotateDown() {
    emit(PuzzleState(
        transformation: Matrix4.rotationX(pi / 2)
          ..multiply(state.transformation)));
  }
}
