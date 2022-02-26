import 'package:jac_slide_puzzle/models/models.dart';
import 'dart:developer';

class Puzzle {
  late final List<PuzzleSide> sides;
  final int size;

  Puzzle({this.size = 3}) {
    sides = _generateSides();
  }

  Puzzle.fromTiles({required this.size, required this.sides});

  List<PuzzleSide> _generateSides() {
    var sideList = <PuzzleSide>[];
    for (int side = 0; side < 6; side++) {
      var tiles = <PuzzleTile>[];
      for (int x = 0; x < size; x++) {
        for (int y = 0; y < size; y++) {
          if (side == 0 && x == size - 1 && y == size - 1) {
            tiles.add(PuzzleTile(Position(x, y, side), Position(x, y, side),
                isWhiteSpace: true));
          } else {
            tiles.add(PuzzleTile(Position(x, y, side), Position(x, y, side)));
          }
        }
      }
      sideList.add(PuzzleSide(tiles));
    }
    return sideList;
  }

  Puzzle moveTile(PuzzleTile tile) {
    var whiteSpacePosition = _getWhiteSpacePosition();
    var currentPosition = tile.currentPosition;
    if (whiteSpacePosition.side == currentPosition.side) {
      if ((whiteSpacePosition.x - 1 == currentPosition.x &&
              whiteSpacePosition.y == currentPosition.y) ||
          (whiteSpacePosition.x + 1 == currentPosition.x &&
              whiteSpacePosition.y == currentPosition.y) ||
          (whiteSpacePosition.x == currentPosition.x &&
              whiteSpacePosition.y - 1 == currentPosition.y) ||
          (whiteSpacePosition.x == currentPosition.x &&
              whiteSpacePosition.y + 1 == currentPosition.y)) {
        return Puzzle.fromTiles(
            size: size, sides: _swapTiles(whiteSpacePosition, currentPosition));
      }
      return this;
    } else {
      return this;
    }
  }

  Position _getWhiteSpacePosition() {
    for (PuzzleSide side in sides) {
      for (PuzzleTile tile in side.tiles) {
        if (tile.isWhiteSpace) return tile.currentPosition;
      }
    }
    return const Position(-1, -1, -1);
  }

  List<PuzzleSide> _swapTiles(Position pos1, Position pos2) {
    //Need to update positions of tiles...
    var tiles = sides[pos1.side].tiles;
    int index1 = 0, index2 = 0;

    for (int i = 0; i < tiles.length; i++) {
      var pos = tiles[i].currentPosition;
      if (pos.x == pos1.x && pos.y == pos1.y) {
        index1 = i;
      }
      if (pos.x == pos2.x && pos.y == pos2.y) {
        index2 = i;
      }
    }
    var temptile = tiles[index1];

    tiles[index1] = tiles[index2].copyWith(currentPosition: pos1);
    tiles[index2] = temptile.copyWith(currentPosition: pos2);

    return sides;
  }
}
