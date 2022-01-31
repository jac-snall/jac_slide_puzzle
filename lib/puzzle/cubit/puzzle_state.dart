part of 'puzzle_cubit.dart';

class PuzzleState extends Equatable {
  PuzzleState({required this.transformation});

  final Matrix4 transformation;
  Matrix4 skew = Matrix4.identity()
    ..rotateX(pi / 16)
    ..rotateY(pi / 16);

  @override
  List<Object> get props => [transformation];
}
