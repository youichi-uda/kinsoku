import 'character_classifier.dart';
import 'models/position.dart';

/// Yakumono (Japanese punctuation) position adjuster
class YakumonoAdjuster {
  // Performance: Static const sets are created once at class load time

  /// Half-width yakumono characters
  static const _halfWidthYakumono = {'。', '、', '・', '！', '？', '：', '；'};

  /// Hangable yakumono characters (burasage-gumi)
  static const _hangableYakumono = {'。', '、', '！', '？'};

  /// Japanese sentence-ending punctuation (kuten, touten)
  static const _sentencePunctuation = {'。', '、'};

  /// Leader characters (ellipsis, two-dot leader)
  static const _leaders = {'…', '‥'};

  /// Full-size punctuation marks
  static const _fullSizePunctuation = {'！', '？'};

  /// Adjust yakumono position for better typography
  ///
  /// [character] The character to adjust
  /// [basePosition] The base position
  /// [fontSize] The font size
  /// [adjustYakumono] Whether yakumono adjustment is enabled
  /// [useVerticalGlyphs] Whether using OpenType 'vert' feature (font handles positioning)
  ///
  /// Returns the adjusted position
  static Position adjustPosition(
    String character,
    Position basePosition, {
    required double fontSize,
    required bool adjustYakumono,
    bool useVerticalGlyphs = false,
  }) {
    if (!adjustYakumono || useVerticalGlyphs) {
      return basePosition;
    }

    // Apply fine-tuning based on character type
    double xOffset = 0.0;
    double yOffset = 0.0;

    // Position punctuation marks at top-right of the virtual cell
    if (_sentencePunctuation.contains(character)) {
      // Move right and up within the virtual cell
      xOffset = fontSize * 0.75;  // Move right by 3/4 of fontSize
      yOffset = -fontSize * 0.75; // Move up by 3/4 of fontSize
    } else if (CharacterClassifier.isSmallKana(character)) {
      // Position small kana: vertically centered, horizontally to the right (JLREQ)
      xOffset = fontSize * 0.25;  // Move right by 1/4 of fontSize
      yOffset = 0.0;              // Keep vertically centered
    }

    return Position(basePosition.x + xOffset, basePosition.y + yOffset);
  }

  /// Check if yakumono should be treated as half-width
  static bool isHalfWidthYakumono(String character) {
    return _halfWidthYakumono.contains(character);
  }

  /// Get width of yakumono (0.5 for half-width, 1.0 for full-width)
  static double getYakumonoWidth(String character) {
    return _halfWidthYakumono.contains(character) ? 0.5 : 1.0;
  }

  /// Check if yakumono can be hung (burasage-gumi)
  static bool canHang(String character) {
    return _hangableYakumono.contains(character);
  }

  /// Get gyoto indent amount for opening brackets
  static double getGyotoIndent(String character) {
    // Use CharacterClassifier to avoid duplication
    if (CharacterClassifier.isOpeningBracket(character)) {
      return 0.1; // 0.1 character width
    }
    return 0.0;
  }

  /// Get spacing adjustment for consecutive yakumono
  static double getConsecutiveYakumonoSpacing(
    String char1,
    String char2, {
    bool useVerticalGlyphs = false,
  }) {
    // Skip adjustments when using vertical glyphs (font handles spacing)
    if (useVerticalGlyphs) {
      return 0.0;
    }

    // Widen spacing after ellipsis and two-dot leader
    if (_leaders.contains(char1)) {
      return 0.4; // Add extra space after leaders
    }

    // Widen spacing after full-size exclamation and question marks
    if (_fullSizePunctuation.contains(char1)) {
      return 0.4; // Add extra space after ！？
    }

    // Tighten spacing between closing bracket and sentence punctuation
    // Use CharacterClassifier to avoid duplication
    if (CharacterClassifier.isClosingBracket(char1) &&
        _sentencePunctuation.contains(char2)) {
      return -0.3;
    }

    // Tighten spacing between sentence punctuation and closing bracket
    if (_sentencePunctuation.contains(char1) &&
        CharacterClassifier.isClosingBracket(char2)) {
      return -0.3;
    }

    return 0.0;
  }
}
