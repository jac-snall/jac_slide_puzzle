part of 'puzzle_cubit.dart';

class PuzzleState extends Equatable {
  PuzzleState({
    required this.transformation,
    required this.puzzle,
  });

  final Matrix4 transformation;
  final Matrix4 skew = Matrix4.identity()
    ..rotateX(pi / 16)
    ..rotateY(pi / 16);

  // Puzzle model
  final Puzzle puzzle;

  //Copies the Puzzle state
  PuzzleState copyWith({
    Matrix4? transformation,
    Puzzle? puzzle,
  }) {
    return PuzzleState(
      transformation: transformation ?? this.transformation,
      puzzle: puzzle ?? this.puzzle,
    );
  }

  @override
  List<Object> get props => [transformation, puzzle];
}
