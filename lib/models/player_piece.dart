class PlayerPiece {
  int x;
  int y;
  int initX;
  int initY;
  int color;

  PlayerPiece(this.x, this.y, this.color)
      : initX = x,
        initY = y;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerPiece &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          color == other.color &&
          initX == other.initX &&
          initY == other.initY;

  @override
  int get hashCode =>
      x.hashCode ^
      y.hashCode ^
      color.hashCode ^
      initY.hashCode ^
      initX.hashCode;
}
