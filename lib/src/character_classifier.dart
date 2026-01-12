import 'models/character_type.dart';

/// Classifier for determining character types and properties
class CharacterClassifier {
  // Performance: Static const sets are created once at class load time

  /// Yakumono characters (Japanese typography symbols)
  static const _yakumonoChars = {
    '。', '、', '・', '（', '）', '「', '」', '【', '】',
    '『', '』', '〈', '〉', '《', '》', '！', '？', '：', '；',
    'ー', // Long vowel mark (U+30FC)
    '―', // Horizontal bar / Dash (U+2015)
    '—', // Em dash (U+2014)
    '–', // En dash (U+2013)
    '－', // Fullwidth hyphen-minus (U+FF0D)
    '〜', '…', '‥', '＿', '＝',
  };

  /// Rotatable yakumono characters (need rotation in vertical text)
  static const _rotatableYakumono = {
    '（', '）', '「', '」', '【', '】', '『', '』',
    '〈', '〉', '《', '》',
    'ー', // Long vowel mark (U+30FC)
    '―', // Horizontal bar / Dash (U+2015)
    '—', // Em dash (U+2014)
    '–', // En dash (U+2013)
    '－', // Fullwidth hyphen-minus (U+FF0D)
    '〜', '…', '‥',
  };

  /// Small kana characters (includes JIS X 4051 class 8)
  static const _smallKana = {
    'ぁ', 'ぃ', 'ぅ', 'ぇ', 'ぉ', // small hiragana vowels
    'ゃ', 'ゅ', 'ょ', 'ゎ', 'っ', // small hiragana
    'ゕ', 'ゖ', // small hiragana ka, ke
    'ァ', 'ィ', 'ゥ', 'ェ', 'ォ', // small katakana vowels
    'ャ', 'ュ', 'ョ', 'ヮ', 'ッ', // small katakana
    'ヵ', 'ヶ', // small katakana ka, ke
  };

  /// Opening brackets
  static const _openingBrackets = {'（', '「', '【', '『', '〈', '《'};

  /// Closing brackets
  static const _closingBrackets = {'）', '」', '】', '』', '〉', '》'};

  /// Classify a single character
  ///
  /// Supports surrogate pairs for characters outside BMP (e.g., CJK Extension B)
  static CharacterType classify(String character) {
    if (character.isEmpty) return CharacterType.space;

    // Use runes for proper surrogate pair handling
    final codePoint = character.runes.first;

    // Space (ASCII space and ideographic space)
    if (codePoint == 0x0020 || codePoint == 0x3000) {
      return CharacterType.space;
    }

    // Latin alphabet (half-width and full-width)
    if ((codePoint >= 0x0041 && codePoint <= 0x005A) || // A-Z
        (codePoint >= 0x0061 && codePoint <= 0x007A) || // a-z
        (codePoint >= 0xFF21 && codePoint <= 0xFF3A) || // Ａ-Ｚ
        (codePoint >= 0xFF41 && codePoint <= 0xFF5A)) { // ａ-ｚ
      return CharacterType.latin;
    }

    // Numbers (half-width and full-width)
    if ((codePoint >= 0x0030 && codePoint <= 0x0039) || // 0-9
        (codePoint >= 0xFF10 && codePoint <= 0xFF19)) { // ０-９
      return CharacterType.number;
    }

    // Hiragana
    if (codePoint >= 0x3040 && codePoint <= 0x309F) {
      return CharacterType.hiragana;
    }

    // Yakumono (Japanese punctuation and symbols)
    // Check this before Katakana to catch long vowel mark (ー, U+30FC)
    if (_yakumonoChars.contains(character)) {
      return CharacterType.yakumono;
    }

    // Katakana
    if (codePoint >= 0x30A0 && codePoint <= 0x30FF) {
      return CharacterType.katakana;
    }

    // Punctuation (ASCII punctuation only)
    if (_isPunctuation(codePoint)) {
      return CharacterType.punctuation;
    }

    // CJK Unified Ideographs (Kanji) - with proper surrogate pair support
    if ((codePoint >= 0x4E00 && codePoint <= 0x9FFF) ||   // CJK Unified Ideographs
        (codePoint >= 0x3400 && codePoint <= 0x4DBF) ||   // CJK Extension A
        (codePoint >= 0x20000 && codePoint <= 0x2A6DF) || // CJK Extension B
        (codePoint >= 0x2A700 && codePoint <= 0x2B73F) || // CJK Extension C
        (codePoint >= 0x2B740 && codePoint <= 0x2B81F) || // CJK Extension D
        (codePoint >= 0x2B820 && codePoint <= 0x2CEAF) || // CJK Extension E
        (codePoint >= 0x2CEB0 && codePoint <= 0x2EBEF) || // CJK Extension F
        (codePoint >= 0x30000 && codePoint <= 0x3134F) || // CJK Extension G
        (codePoint >= 0xF900 && codePoint <= 0xFAFF)) {   // CJK Compatibility Ideographs
      return CharacterType.kanji;
    }

    return CharacterType.kanji; // Default for unknown characters
  }

  /// Check if code point is ASCII punctuation
  static bool _isPunctuation(int codePoint) {
    return (codePoint >= 0x0021 && codePoint <= 0x002F) || // !"#$%&'()*+,-./
           (codePoint >= 0x003A && codePoint <= 0x0040) || // :;<=>?@
           (codePoint >= 0x005B && codePoint <= 0x0060) || // [\]^_`
           (codePoint >= 0x007B && codePoint <= 0x007E);   // {|}~
  }

  /// Check if character needs rotation in vertical text
  static bool needsRotation(String character) {
    final type = classify(character);
    return type == CharacterType.latin ||
           type == CharacterType.number ||
           _rotatableYakumono.contains(character);
  }

  /// Check if character is small kana (っゃゅょなど)
  static bool isSmallKana(String character) {
    return _smallKana.contains(character);
  }

  /// Check if character is a long vowel mark
  static bool isLongVowelMark(String character) {
    return character == 'ー';
  }

  /// Check if character is opening bracket
  static bool isOpeningBracket(String character) {
    return _openingBrackets.contains(character);
  }

  /// Check if character is closing bracket
  static bool isClosingBracket(String character) {
    return _closingBrackets.contains(character);
  }
}
