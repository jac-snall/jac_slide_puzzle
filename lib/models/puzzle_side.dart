import 'package:jac_slide_puzzle/models/models.dart';

class PuzzleSide {
  //Index of sides around this side
  final int top, right, bottom, left;

  //List of tiles
  final List<PuzzleTile> tiles;

  const PuzzleSide(this.tiles, this.top, this.right, this.bottom, this.left);
}
