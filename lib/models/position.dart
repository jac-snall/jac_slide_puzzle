class Position {
  final int x, y, side;

  const Position(this.x, this.y, this.side);

  @override
  String toString() {
    return 'x: $x, y: $y, side: $side';
  }
}
