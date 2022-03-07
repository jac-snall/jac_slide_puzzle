import 'package:jac_slide_puzzle/models/models.dart';
import 'dart:math';

import 'dart:developer' as dev;

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

  Puzzle shuffle() {
    final correctPositions = <Position>[];
    final currentPositions = <Position>[];

    // Generate all possible comibinations of positions
    for (int side = 0; side < 6; side++) {
      for (int x = 0; x < size; x++) {
        for (int y = 0; y < size; y++) {
          if (!(side == 0 && x == size - 1 && y == size - 1)) {
            final position = Position(x, y, side);
            correctPositions.add(position);
            currentPositions.add(position);
          }
        }
      }
    }

    Random random = Random();
    correctPositions.shuffle(random);

    // Add whitespace tile
    correctPositions.add(Position(size - 1, size - 1, 0));
    currentPositions.add(Position(size - 1, size - 1, 0));

    List<PuzzleSide> newSides = [];
    for (int i = 0; i < 6; i++) {
      newSides.add(PuzzleSide([]));
    }
    for (int i = 0; i < correctPositions.length; i++) {
      dev.log('$i: (${currentPositions[i]}) (${correctPositions[i]}) ');
      if (i == correctPositions.length - 1) {
        //dev.log('$i: (${currentPositions[i]}) (${correctPositions[i]}) ');
        newSides[currentPositions[i].side].tiles.add(PuzzleTile(
            correctPositions[i], currentPositions[i],
            isWhiteSpace: true));
      } else {
        newSides[currentPositions[i].side]
            .tiles
            .add(PuzzleTile(correctPositions[i], currentPositions[i]));
      }
    }
    dev.log('${currentPositions.length}');
    return Puzzle.fromTiles(size: size, sides: newSides);
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
                  whiteSpacePosition.x == size - 1 &&
                  tilePosition.y == whiteSpacePosition.y) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 3:
              if (tilePosition.x == size - 1 &&
                  whiteSpacePosition.x == 0 &&
                  tilePosition.y == whiteSpacePosition.y) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 4:
              if (tilePosition.y == 0 &&
                  whiteSpacePosition.y == size - 1 &&
                  tilePosition.x == whiteSpacePosition.x) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 5:
              if (tilePosition.y == size - 1 &&
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
              if (tilePosition.x == size - 1 &&
                  whiteSpacePosition.x == size - 1 &&
                  tilePosition.y == size - whiteSpacePosition.y - 1) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 4:
              if (tilePosition.y == size - 1 &&
                  whiteSpacePosition.y == 0 &&
                  tilePosition.x == whiteSpacePosition.x) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 5:
              if (tilePosition.y == 0 &&
                  whiteSpacePosition.y == size - 1 &&
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
              if (tilePosition.x == size - 1 &&
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
              if (tilePosition.y == size - 1 &&
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
                  whiteSpacePosition.x == size - 1 &&
                  tilePosition.y == whiteSpacePosition.y) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 1:
              if (tilePosition.x == size - 1 &&
                  whiteSpacePosition.x == size - 1 &&
                  tilePosition.y == size - whiteSpacePosition.y - 1) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 4:
              if (tilePosition.y == 0 &&
                  whiteSpacePosition.x == size - 1 &&
                  tilePosition.x == size - whiteSpacePosition.y - 1) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 5:
              if (tilePosition.y == size - 1 &&
                  whiteSpacePosition.x == size - 1 &&
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
              if (tilePosition.y == size - 1 &&
                  whiteSpacePosition.y == 0 &&
                  tilePosition.x == whiteSpacePosition.x) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 1:
              if (tilePosition.y == 0 &&
                  whiteSpacePosition.y == size - 1 &&
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
              if (tilePosition.x == size - 1 &&
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
                  whiteSpacePosition.y == size - 1 &&
                  tilePosition.x == whiteSpacePosition.x) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 1:
              if (tilePosition.y == size - 1 &&
                  whiteSpacePosition.y == 0 &&
                  tilePosition.x == whiteSpacePosition.x) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 2:
              if (tilePosition.x == 0 &&
                  whiteSpacePosition.y == size - 1 &&
                  tilePosition.y == size - whiteSpacePosition.x - 1) {
                return Puzzle.fromTiles(
                    size: size,
                    sides: _swapTiles(whiteSpacePosition, tilePosition));
              }
              break;
            case 3:
              if (tilePosition.x == size - 1 &&
                  whiteSpacePosition.y == size - 1 &&
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

  //Get the positon of the tiles around the whitespace tile
  Map<String, Position> getWhiteSpaceNeighbours() {
    var neighbours = <String, Position>{};

    var whiteSpacePosition = _getWhiteSpacePosition();

    // left
    if (whiteSpacePosition.x == 0) {
      switch (whiteSpacePosition.side) {
        case 0:
          neighbours['left'] = Position(size - 1, whiteSpacePosition.y, 2);
          break;
        case 1:
          neighbours['left'] = Position(0, size - whiteSpacePosition.y - 1, 2);
          break;
        case 2:
          neighbours['left'] = Position(0, size - whiteSpacePosition.y - 1, 1);
          break;
        case 3:
          neighbours['left'] = Position(size - 1, whiteSpacePosition.y, 0);
          break;
        case 4:
          neighbours['left'] = Position(whiteSpacePosition.y, 0, 2);
          break;
        case 5:
          neighbours['left'] =
              Position(size - whiteSpacePosition.y - 1, size - 1, 2);
          break;
      }
    } else {
      neighbours['left'] = Position(
        whiteSpacePosition.x - 1,
        whiteSpacePosition.y,
        whiteSpacePosition.side,
      );
    }

    // right
    if (whiteSpacePosition.x == size - 1) {
      switch (whiteSpacePosition.side) {
        case 0:
          neighbours['right'] = Position(0, whiteSpacePosition.y, 3);
          break;
        case 1:
          neighbours['right'] =
              Position(size - 1, size - whiteSpacePosition.y - 1, 3);
          break;
        case 2:
          neighbours['right'] = Position(0, whiteSpacePosition.y, 0);
          break;
        case 3:
          neighbours['right'] =
              Position(size - 1, size - whiteSpacePosition.y - 1, 1);
          break;
        case 4:
          neighbours['right'] = Position(size - whiteSpacePosition.y - 1, 0, 3);
          break;
        case 5:
          neighbours['right'] = Position(whiteSpacePosition.y, size - 1, 3);
          break;
      }
    } else {
      neighbours['right'] = Position(
        whiteSpacePosition.x + 1,
        whiteSpacePosition.y,
        whiteSpacePosition.side,
      );
    }

    // top
    if (whiteSpacePosition.y == 0) {
      switch (whiteSpacePosition.side) {
        case 0:
          neighbours['top'] = Position(whiteSpacePosition.x, size - 1, 4);
          break;
        case 1:
          neighbours['top'] = Position(whiteSpacePosition.x, size - 1, 5);
          break;
        case 2:
          neighbours['top'] = Position(0, whiteSpacePosition.x, 4);
          break;
        case 3:
          neighbours['top'] =
              Position(size - 1, size - whiteSpacePosition.x - 1, 4);
          break;
        case 4:
          neighbours['top'] = Position(whiteSpacePosition.x, size - 1, 1);
          break;
        case 5:
          neighbours['top'] = Position(whiteSpacePosition.x, size - 1, 0);
          break;
      }
    } else {
      neighbours['top'] = Position(
        whiteSpacePosition.x,
        whiteSpacePosition.y - 1,
        whiteSpacePosition.side,
      );
    }

    // bottom
    if (whiteSpacePosition.y == size - 1) {
      switch (whiteSpacePosition.side) {
        case 0:
          neighbours['bottom'] = Position(whiteSpacePosition.x, 0, 5);
          break;
        case 1:
          neighbours['bottom'] = Position(whiteSpacePosition.x, 0, 4);
          break;
        case 2:
          neighbours['bottom'] =
              Position(0, size - whiteSpacePosition.x - 1, 5);
          break;
        case 3:
          neighbours['bottom'] = Position(size - 1, whiteSpacePosition.x, 5);
          break;
        case 4:
          neighbours['bottom'] = Position(whiteSpacePosition.x, 0, 0);
          break;
        case 5:
          neighbours['bottom'] = Position(whiteSpacePosition.x, 0, 1);
          break;
      }
    } else {
      neighbours['bottom'] = Position(
        whiteSpacePosition.x,
        whiteSpacePosition.y + 1,
        whiteSpacePosition.side,
      );
    }

    return neighbours;
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
