import 'package:equatable/equatable.dart';

class Position extends Equatable {
  final int x, y, side;

  const Position(this.x, this.y, this.side);

  @override
  String toString() {
    return 'x: $x, y: $y, side: $side';
  }

  @override
  List<Object> get props => [x, y, side];
}
