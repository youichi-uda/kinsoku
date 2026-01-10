/// A 2D position with x and y coordinates
///
/// This is a pure Dart alternative to Flutter's Offset class.
class Position {
  /// The x coordinate
  final double x;

  /// The y coordinate
  final double y;

  /// Creates a position with the given x and y coordinates
  const Position(this.x, this.y);

  /// Adds two positions together
  Position operator +(Position other) {
    return Position(x + other.x, y + other.y);
  }

  /// Subtracts one position from another
  Position operator -(Position other) {
    return Position(x - other.x, y - other.y);
  }

  /// Multiplies the position by a scalar
  Position operator *(double scalar) {
    return Position(x * scalar, y * scalar);
  }

  /// Divides the position by a scalar
  Position operator /(double scalar) {
    return Position(x / scalar, y / scalar);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Position && x == other.x && y == other.y;
  }

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Position($x, $y)';
}
