import 'package:jac_slide_puzzle/models/models.dart';

class Puzzle {
  late final List<PuzzleSide> sides;
  final int size;

  Puzzle({this.size = 3}) {
    sides = _generateSides();
  }

  List<PuzzleSide> _generateSides() {
    var sideList = <PuzzleSide>[];
    for (int i = 0; i < 6; i++) {
      var tiles = <PuzzleTile>[
        for (int j = 0; j < size * size; j++) PuzzleTile(i)
      ];
      if (i < 4) {
        sideList.add(PuzzleSide(tiles, 4, ((i + 1) % 4), 5, ((i - 1) % 4)));
      } else if (i == 4) {
        sideList.add(PuzzleSide(tiles, 2, 1, 0, 3));
      } else {
        sideList.add(PuzzleSide(tiles, 0, 1, 2, 3));
      }
    }
    return sideList;
  }
}
