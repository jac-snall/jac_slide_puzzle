import 'package:jac_slide_puzzle/models/models.dart';

class PuzzleSide {
  //List of tiles
  final List<PuzzleTile> tiles;

  const PuzzleSide(this.tiles);

  @override
  String toString() {
    return '$tiles';
  }
}
