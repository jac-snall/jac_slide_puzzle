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
    var tilePosition = tile.currentPosition;
    if (whiteSpacePosition.side == tilePosition.side) {
      if ((whiteSpacePosition.x - 1 == tilePosition.x &&
              whiteSpacePosition.y == tilePosition.y) ||
          (whiteSpacePosition.x + 1 == tilePosition.x &&
              whiteSpacePosition.y == tilePosition.y) ||
          (whiteSpacePosition.x == tilePosition.x &&
              whiteSpacePosition.y - 1 == tilePosition.y) ||
          (whiteSpacePosition.x == tilePosition.x &&
              whiteSpacePosition.y + 1 == tilePosition.y)) {
        return Puzzle.fromTiles(
            size: size, sides: _swapTiles(whiteSpacePosition, tilePosition));
      }
      return this;
    } else {
      switch (tilePosition.side) {
        case 0:
          switch (whiteSpacePosition.side) {
            case 2:
              if (tilePosition.x == 0 &&
                  whiteSpacePosition.x == 2 &&
                  tilePosition.y == whiteSpacePosition.y) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 3:
              if (tilePosition.x == 2 &&
                  whiteSpacePosition.x == 0 &&
                  tilePosition.y == whiteSpacePosition.y) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 4:
              if (tilePosition.y == 0 &&
                  whiteSpacePosition.y == 2 &&
                  tilePosition.x == whiteSpacePosition.x) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 5:
              if (tilePosition.y == 2 &&
                  whiteSpacePosition.y == 0 &&
                  tilePosition.x == whiteSpacePosition.x) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
          }
          break;
        case 1:
          switch (whiteSpacePosition.side) {
            case 2:
              if (tilePosition.x == 0 &&
                  whiteSpacePosition.x == 0 &&
                  tilePosition.y == size - whiteSpacePosition.y - 1) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 3:
              if (tilePosition.x == 2 &&
                  whiteSpacePosition.x == 2 &&
                  tilePosition.y == size - whiteSpacePosition.y - 1) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 4:
              if (tilePosition.y == 2 &&
                  whiteSpacePosition.y == 0 &&
                  tilePosition.x == whiteSpacePosition.x) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 5:
              if (tilePosition.y == 0 &&
                  whiteSpacePosition.y == 2 &&
                  tilePosition.x == whiteSpacePosition.x) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
          }
          break;
        case 2:
          switch (whiteSpacePosition.side) {
            case 0:
              if (tilePosition.x == 2 &&
                  whiteSpacePosition.x == 0 &&
                  tilePosition.y == whiteSpacePosition.y) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 1:
              if (tilePosition.x == 0 &&
                  whiteSpacePosition.x == 0 &&
                  tilePosition.y == size - whiteSpacePosition.y - 1) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 4:
              if (tilePosition.y == 0 &&
                  whiteSpacePosition.x == 0 &&
                  tilePosition.x == whiteSpacePosition.y) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 5:
              if (tilePosition.y == 2 &&
                  whiteSpacePosition.x == 0 &&
                  tilePosition.x == size - whiteSpacePosition.y - 1) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
          }
          break;
        case 3:
          switch (whiteSpacePosition.side) {
            case 0:
              if (tilePosition.x == 0 &&
                  whiteSpacePosition.x == 2 &&
                  tilePosition.y == whiteSpacePosition.y) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 1:
              if (tilePosition.x == 2 &&
                  whiteSpacePosition.x == 2 &&
                  tilePosition.y == size - whiteSpacePosition.y - 1) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 4:
              if (tilePosition.y == 0 &&
                  whiteSpacePosition.x == 2 &&
                  tilePosition.x == size - whiteSpacePosition.y - 1) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 5:
              if (tilePosition.y == 2 &&
                  whiteSpacePosition.x == 2 &&
                  tilePosition.x == whiteSpacePosition.y) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
          }
          break;
        case 4:
          switch (whiteSpacePosition.side) {
            case 0:
              if (tilePosition.y == 2 &&
                  whiteSpacePosition.y == 0 &&
                  tilePosition.x == whiteSpacePosition.x) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 1:
              if (tilePosition.y == 0 &&
                  whiteSpacePosition.y == 2 &&
                  tilePosition.x == whiteSpacePosition.x) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 2:
              if (tilePosition.x == 0 &&
                  whiteSpacePosition.y == 0 &&
                  tilePosition.y == whiteSpacePosition.x) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 3:
              if (tilePosition.x == 2 &&
                  whiteSpacePosition.y == 0 &&
                  tilePosition.y == size - whiteSpacePosition.x - 1) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
          }
          break;
        case 5:
          switch (whiteSpacePosition.side) {
            case 0:
              if (tilePosition.y == 0 &&
                  whiteSpacePosition.y == 2 &&
                  tilePosition.x == whiteSpacePosition.x) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 1:
              if (tilePosition.y == 2 &&
                  whiteSpacePosition.y == 0 &&
                  tilePosition.x == whiteSpacePosition.x) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 2:
              if (tilePosition.x == 0 &&
                  whiteSpacePosition.y == 2 &&
                  tilePosition.y == size - whiteSpacePosition.x - 1) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 3:
              if (tilePosition.x == 2 &&
                  whiteSpacePosition.y == 2 &&
                  tilePosition.y == whiteSpacePosition.x) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
          }
          break;
      }

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
    int index1 = 0, index2 = 0;

    for (var side in sides) {
      for (int i = 0; i < side.tiles.length; i++) {
        var pos = side.tiles[i].currentPosition;
        if (pos.x == pos1.x && pos.y == pos1.y) {
          index1 = i;
        }
        if (pos.x == pos2.x && pos.y == pos2.y) {
          index2 = i;
        }
      }
    }

    var temptile = sides[pos1.side].tiles[index1];

    sides[pos1.side].tiles[index1] =
        sides[pos2.side].tiles[index2].copyWith(currentPosition: pos1);
    sides[pos2.side].tiles[index2] = temptile.copyWith(currentPosition: pos2);

    return sides;
  }
}
