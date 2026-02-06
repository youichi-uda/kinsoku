/// JIS X 4051:2004 Complete Character Class Definitions
///
/// This file provides complete character class definitions according to
/// JIS X 4051:2004 (Japanese document composition method).
///
/// Reference: https://kikakurui.com/x4/X4051-2004-02.html
library;

class JisX4051Classes {
  /// Class 1: Opening brackets (始め括弧類)
  /// 行末禁則（gyomatsu kinsoku） - Cannot appear at line end
  static const class1_openingBrackets = {
    '(': '\u0028', // LEFT PARENTHESIS
    '（': '\uFF08', // FULLWIDTH LEFT PARENTHESIS
    '[': '\u005B', // LEFT SQUARE BRACKET
    '［': '\uFF3B', // FULLWIDTH LEFT SQUARE BRACKET
    '{': '\u007B', // LEFT CURLY BRACKET
    '｛': '\uFF5B', // FULLWIDTH LEFT CURLY BRACKET
    '〈': '\u3008', // LEFT ANGLE BRACKET
    '《': '\u300A', // LEFT DOUBLE ANGLE BRACKET
    '「': '\u300C', // LEFT CORNER BRACKET
    '『': '\u300E', // LEFT WHITE CORNER BRACKET
    '【': '\u3010', // LEFT BLACK LENTICULAR BRACKET
    '〔': '\u3014', // LEFT TORTOISE SHELL BRACKET
    '〖': '\u3016', // LEFT WHITE LENTICULAR BRACKET
    '〘': '\u3018', // LEFT WHITE TORTOISE SHELL BRACKET
    '〚': '\u301A', // LEFT WHITE SQUARE BRACKET
    '｟': '\uFF5F', // FULLWIDTH LEFT WHITE PARENTHESIS
    '｢': '\uFF62', // HALFWIDTH LEFT CORNER BRACKET
    '\u2018': '\u2018', // LEFT SINGLE QUOTATION MARK
    '\u201C': '\u201C', // LEFT DOUBLE QUOTATION MARK
    '«': '\u00AB', // LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
    '〝': '\u301D', // REVERSED DOUBLE PRIME QUOTATION MARK
  };

  /// Class 2: Closing brackets (終わり括弧類)
  /// 行頭禁則（gyoto kinsoku） - Cannot appear at line start
  static const class2_closingBrackets = {
    ')': '\u0029', // RIGHT PARENTHESIS
    '）': '\uFF09', // FULLWIDTH RIGHT PARENTHESIS
    ']': '\u005D', // RIGHT SQUARE BRACKET
    '］': '\uFF3D', // FULLWIDTH RIGHT SQUARE BRACKET
    '}': '\u007D', // RIGHT CURLY BRACKET
    '｝': '\uFF5D', // FULLWIDTH RIGHT CURLY BRACKET
    '〉': '\u3009', // RIGHT ANGLE BRACKET
    '》': '\u300B', // RIGHT DOUBLE ANGLE BRACKET
    '」': '\u300D', // RIGHT CORNER BRACKET
    '』': '\u300F', // RIGHT WHITE CORNER BRACKET
    '】': '\u3011', // RIGHT BLACK LENTICULAR BRACKET
    '〕': '\u3015', // RIGHT TORTOISE SHELL BRACKET
    '〗': '\u3017', // RIGHT WHITE LENTICULAR BRACKET
    '〙': '\u3019', // RIGHT WHITE TORTOISE SHELL BRACKET
    '〛': '\u301B', // RIGHT WHITE SQUARE BRACKET
    '｠': '\uFF60', // FULLWIDTH RIGHT WHITE PARENTHESIS
    '｣': '\uFF63', // HALFWIDTH RIGHT CORNER BRACKET
    '\u2019': '\u2019', // RIGHT SINGLE QUOTATION MARK
    '\u201D': '\u201D', // RIGHT DOUBLE QUOTATION MARK
    '»': '\u00BB', // RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
    '〟': '\u301F', // LOW DOUBLE PRIME QUOTATION MARK
  };

  /// Class 3: Delimiter characters (Japanese) (句読点類)
  /// 行頭禁則（gyoto kinsoku） - Cannot appear at line start
  static const class3_delimitersJa = {
    '、': '\u3001', // IDEOGRAPHIC COMMA
    '。': '\u3002', // IDEOGRAPHIC FULL STOP
    '，': '\uFF0C', // FULLWIDTH COMMA
    '．': '\uFF0E', // FULLWIDTH FULL STOP
  };

  /// Class 4: Period/Comma (Western) (ピリオド・カンマ)
  /// 行頭禁則（gyoto kinsoku） - Cannot appear at line start
  static const class4_periodComma = {
    ',': '\u002C', // COMMA
    '.': '\u002E', // FULL STOP
  };

  /// Class 5: Middle dots (中点類)
  /// 行頭禁則（gyoto kinsoku） - Cannot appear at line start
  static const class5_middleDots = {
    '・': '\u30FB', // KATAKANA MIDDLE DOT
    ':': '\u003A', // COLON
    ';': '\u003B', // SEMICOLON
    '：': '\uFF1A', // FULLWIDTH COLON
    '；': '\uFF1B', // FULLWIDTH SEMICOLON
  };

  /// Class 6: Inseparable characters (分離禁止文字)
  /// 行頭禁則（gyoto kinsoku） - Cannot appear at line start
  static const class6_inseparable = {
    '!': '\u0021', // EXCLAMATION MARK
    '?': '\u003F', // QUESTION MARK
    '！': '\uFF01', // FULLWIDTH EXCLAMATION MARK
    '？': '\uFF1F', // FULLWIDTH QUESTION MARK
  };

  /// Class 7: Prolonged sound mark (長音記号)
  /// 行頭禁則（gyoto kinsoku） - Cannot appear at line start
  static const class7_prolongedSound = {
    'ー': '\u30FC', // KATAKANA-HIRAGANA PROLONGED SOUND MARK
  };

  /// Class 8: Small kana (小書きの仮名)
  /// 行頭禁則（gyoto kinsoku） - Cannot appear at line start
  static const class8_smallKana = {
    // Hiragana small letters
    'ぁ': '\u3041', // HIRAGANA LETTER SMALL A
    'ぃ': '\u3043', // HIRAGANA LETTER SMALL I
    'ぅ': '\u3045', // HIRAGANA LETTER SMALL U
    'ぇ': '\u3047', // HIRAGANA LETTER SMALL E
    'ぉ': '\u3049', // HIRAGANA LETTER SMALL O
    'ゃ': '\u3083', // HIRAGANA LETTER SMALL YA
    'ゅ': '\u3085', // HIRAGANA LETTER SMALL YU
    'ょ': '\u3087', // HIRAGANA LETTER SMALL YO
    'ゎ': '\u308E', // HIRAGANA LETTER SMALL WA
    'っ': '\u3063', // HIRAGANA LETTER SMALL TU
    'ゕ': '\u3095', // HIRAGANA LETTER SMALL KA
    'ゖ': '\u3096', // HIRAGANA LETTER SMALL KE
    // Katakana small letters
    'ァ': '\u30A1', // KATAKANA LETTER SMALL A
    'ィ': '\u30A3', // KATAKANA LETTER SMALL I
    'ゥ': '\u30A5', // KATAKANA LETTER SMALL U
    'ェ': '\u30A7', // KATAKANA LETTER SMALL E
    'ォ': '\u30A9', // KATAKANA LETTER SMALL O
    'ヵ': '\u30F5', // KATAKANA LETTER SMALL KA
    'ヶ': '\u30F6', // KATAKANA LETTER SMALL KE
    'ャ': '\u30E3', // KATAKANA LETTER SMALL YA
    'ュ': '\u30E5', // KATAKANA LETTER SMALL YU
    'ョ': '\u30E7', // KATAKANA LETTER SMALL YO
    'ヮ': '\u30EE', // KATAKANA LETTER SMALL WA
    'ッ': '\u30C3', // KATAKANA LETTER SMALL TU
  };

  /// Class 9: Iteration marks (繰り返し記号)
  /// 行頭禁則（gyoto kinsoku） - Cannot appear at line start
  static const class9_iterationMarks = {
    'ゝ': '\u309D', // HIRAGANA ITERATION MARK
    'ゞ': '\u309E', // HIRAGANA VOICED ITERATION MARK
    'ヽ': '\u30FD', // KATAKANA ITERATION MARK
    'ヾ': '\u30FE', // KATAKANA VOICED ITERATION MARK
    '々': '\u3005', // IDEOGRAPHIC ITERATION MARK
    '〃': '\u3003', // DITTO MARK
    '〻': '\u303B', // VERTICAL IDEOGRAPHIC ITERATION MARK
  };

  /// Class 10: Currency symbols (通貨記号)
  /// 行末禁則（gyomatsu kinsoku） - Cannot appear at line end
  /// Note: Unit symbols like ℃, ° moved to class 11 (postfix abbreviations)
  static const class10_currencyUnits = {
    '\$': '\u0024', // DOLLAR SIGN
    '¢': '\u00A2', // CENT SIGN
    '£': '\u00A3', // POUND SIGN
    '¥': '\u00A5', // YEN SIGN
    '€': '\u20AC', // EURO SIGN
    '￠': '\uFFE0', // FULLWIDTH CENT SIGN
    '￡': '\uFFE1', // FULLWIDTH POUND SIGN
    '￥': '\uFFE5', // FULLWIDTH YEN SIGN
    '%': '\u0025', // PERCENT SIGN
    '％': '\uFF05', // FULLWIDTH PERCENT SIGN
  };

  /// Class 11: Postfix abbreviations (後置略語・単位記号)
  /// 行頭禁則（gyoto kinsoku） - Cannot appear at line start
  static const class11_postfixAbbrev = {
    '℃': '\u2103', // DEGREE CELSIUS
    '℉': '\u2109', // DEGREE FAHRENHEIT
    '°': '\u00B0', // DEGREE SIGN
    '′': '\u2032', // PRIME
    '″': '\u2033', // DOUBLE PRIME
  };

  /// Class 12: Prefix abbreviations (前置略語)
  /// 行末禁則（gyomatsu kinsoku） - Cannot appear at line end
  static const class12_prefixAbbrev = {
    '№': '\u2116', // NUMERO SIGN
    '＃': '\uFF03', // FULLWIDTH NUMBER SIGN
    '#': '\u0023', // NUMBER SIGN
  };

  /// Class 13: Dashes (ダッシュ・ハイフン)
  /// Special handling for consecutive occurrence
  static const class13_dashes = {
    '‐': '\u2010', // HYPHEN
    '‑': '\u2011', // NON-BREAKING HYPHEN
    '‒': '\u2012', // FIGURE DASH
    '–': '\u2013', // EN DASH
    '—': '\u2014', // EM DASH
    '―': '\u2015', // HORIZONTAL BAR
    '−': '\u2212', // MINUS SIGN
    '-': '\u002D', // HYPHEN-MINUS
    '－': '\uFF0D', // FULLWIDTH HYPHEN-MINUS
    '─': '\u2500', // BOX DRAWINGS LIGHT HORIZONTAL
  };

  /// Class 14: Ellipsis and leaders (三点リーダー・二点リーダー)
  /// Special handling - must appear in pairs
  static const class14_ellipsis = {
    '…': '\u2026', // HORIZONTAL ELLIPSIS
    '‥': '\u2025', // TWO DOT LEADER
    '⋯': '\u22EF', // MIDLINE HORIZONTAL ELLIPSIS
  };

  /// Class 15: Full stop/Comma combinations
  /// 行頭禁則（gyoto kinsoku） - Cannot appear at line start
  static const class15_combiningMarks = {
    '゛': '\u309B', // KATAKANA-HIRAGANA VOICED SOUND MARK
    '゜': '\u309C', // KATAKANA-HIRAGANA SEMI-VOICED SOUND MARK
  };

  /// Class 16: Other symbols that cannot start a line
  static const class16_otherGyoto = {
    '〳': '\u3033', // VERTICAL KANA REPEAT MARK UPPER HALF
    '〴': '\u3034', // VERTICAL KANA REPEAT WITH VOICED SOUND MARK UPPER HALF
    '〵': '\u3035', // VERTICAL KANA REPEAT MARK LOWER HALF
    'ヿ': '\u30FF', // KATAKANA DIGRAPH KOTO
  };

  /// Class 17: Unbreakable Western characters
  static const class17_westernUnbreakable = {
    // Combining diacritical marks (cannot appear at line start)
    // These should not be separated from their base character
  };

  // Performance: Cache computed sets to avoid repeated computation
  static Set<String>? _cachedGyotoKinsoku;
  static Set<String>? _cachedGyomatsuKinsoku;
  static Set<String>? _cachedBurasageAllowed;
  static Set<String>? _cachedPairedCharacters;

  /// Get all gyoto kinsoku characters (cannot appear at line start)
  ///
  /// Results are cached for performance.
  static Set<String> getAllGyotoKinsoku() {
    return _cachedGyotoKinsoku ??= {
      ...class2_closingBrackets.keys,
      ...class3_delimitersJa.keys,
      ...class4_periodComma.keys,
      ...class5_middleDots.keys,
      ...class6_inseparable.keys,
      ...class7_prolongedSound.keys,
      ...class8_smallKana.keys,
      ...class9_iterationMarks.keys,
      ...class11_postfixAbbrev.keys,
      ...class15_combiningMarks.keys,
      ...class16_otherGyoto.keys,
    };
  }

  /// Get all gyomatsu kinsoku characters (cannot appear at line end)
  ///
  /// Results are cached for performance.
  static Set<String> getAllGyomatsuKinsoku() {
    return _cachedGyomatsuKinsoku ??= {
      ...class1_openingBrackets.keys,
      ...class10_currencyUnits.keys,
      ...class12_prefixAbbrev.keys,
    };
  }

  /// Get characters that can hang (burasage allowed)
  ///
  /// According to JIS X 4051, these small characters can hang.
  /// Results are cached for performance.
  static Set<String> getBurasageAllowed() {
    return _cachedBurasageAllowed ??= {
      ...class2_closingBrackets.keys,
      ...class3_delimitersJa.keys,
      ...class5_middleDots.keys,
    };
  }

  /// Get paired characters that must not be separated
  ///
  /// Results are cached for performance.
  static Set<String> getPairedCharacters() {
    return _cachedPairedCharacters ??= {
      ...class13_dashes.keys,
      ...class14_ellipsis.keys,
    };
  }

  /// Get all character classes as a map
  static Map<String, Set<String>> getAllClasses() {
    return {
      'class1_openingBrackets': class1_openingBrackets.keys.toSet(),
      'class2_closingBrackets': class2_closingBrackets.keys.toSet(),
      'class3_delimitersJa': class3_delimitersJa.keys.toSet(),
      'class4_periodComma': class4_periodComma.keys.toSet(),
      'class5_middleDots': class5_middleDots.keys.toSet(),
      'class6_inseparable': class6_inseparable.keys.toSet(),
      'class7_prolongedSound': class7_prolongedSound.keys.toSet(),
      'class8_smallKana': class8_smallKana.keys.toSet(),
      'class9_iterationMarks': class9_iterationMarks.keys.toSet(),
      'class10_currencyUnits': class10_currencyUnits.keys.toSet(),
      'class11_postfixAbbrev': class11_postfixAbbrev.keys.toSet(),
      'class12_prefixAbbrev': class12_prefixAbbrev.keys.toSet(),
      'class13_dashes': class13_dashes.keys.toSet(),
      'class14_ellipsis': class14_ellipsis.keys.toSet(),
      'class15_combiningMarks': class15_combiningMarks.keys.toSet(),
      'class16_otherGyoto': class16_otherGyoto.keys.toSet(),
    };
  }
}
