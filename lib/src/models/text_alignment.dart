/// Text alignment for line positioning
///
/// Controls how lines are aligned when they don't fill the entire width/height:
/// - For horizontal text: Controls horizontal alignment (left/center/right)
/// - For vertical text: Controls vertical alignment (top/center/bottom)
enum TextAlignment {
  /// Start alignment
  /// - Horizontal text: Left alignment (天付き)
  /// - Vertical text: Top alignment (天付き)
  start,

  /// Center alignment
  /// - Both horizontal and vertical text: Center alignment
  center,

  /// End alignment
  /// - Horizontal text: Right alignment (地付き)
  /// - Vertical text: Bottom alignment (地付き)
  end,
}
