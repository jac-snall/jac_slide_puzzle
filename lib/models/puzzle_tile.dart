import 'package:jac_slide_puzzle/models/models.dart';

class PuzzleTile {
  final Position correctPosition, currentPosition;
  final bool isWhiteSpace;

  const PuzzleTile(this.correctPosition, this.currentPosition,
      {this.isWhiteSpace = false});

  PuzzleTile copyWith({
    Position? correctPosition,
    Position? currentPosition,
    bool? isWhiteSpace,
  }) {
    return PuzzleTile(
      correctPosition ?? this.correctPosition,
      currentPosition ?? this.currentPosition,
      isWhiteSpace: isWhiteSpace ?? this.isWhiteSpace,
    );
  }

  @override
  String toString() {
    return '($currentPosition) ($correctPosition) ';
  }
}
