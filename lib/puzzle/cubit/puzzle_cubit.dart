import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import 'package:jac_slide_puzzle/models/models.dart';

part 'puzzle_state.dart';

class PuzzleCubit extends Cubit<PuzzleState> {
  PuzzleCubit()
      : super(
          PuzzleState(
            puzzle: Puzzle(),
            transformation: Matrix4.identity(),
          ),
        );

  void rotateLeft() {
    emit(state.copyWith(
      transformation: Matrix4.rotationY(pi / 2)..multiply(state.transformation),
    ));
  }

  void rotateRight() {
    emit(state.copyWith(
      transformation: Matrix4.rotationY(-pi / 2)
        ..multiply(state.transformation),
    ));
  }

  void rotateUp() {
    emit(state.copyWith(
      transformation: Matrix4.rotationX(-pi / 2)
        ..multiply(state.transformation),
    ));
  }

  void rotateDown() {
    emit(state.copyWith(
      transformation: Matrix4.rotationX(pi / 2)..multiply(state.transformation),
    ));
  }
}
