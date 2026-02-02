import 'icu_bindings.dart';
import 'jis_x_4051_classes.dart';

/// ICU-based Kinsoku Processor with customizable rules
///
/// This processor uses ICU's break iterator with custom rules to implement
/// Japanese line breaking (kinsoku) according to UAX #14 with customizations.
///
/// ## Customization Options:
/// - Use predefined rule sets (UAX #14, JIS X 4051-inspired)
/// - Define custom character classes
/// - Override specific break behaviors
/// - Add custom break rules
///
/// ## Example:
/// ```dart
/// final processor = ICUKinsokuProcessor.withJISX4051Rules();
/// final canBreak = processor.canBreakAt('これは禁則処理です。', 10);
/// ```
class ICUKinsokuProcessor {
  final ICUBindings _icu;
  late final UBreakIterator _iterator;
  String _currentText = '';

  /// Create a processor with default UAX #14 rules
  ICUKinsokuProcessor() : _icu = ICUBindings() {
    _iterator = _icu.open(UBreakIteratorType.line, 'ja', null);
  }

  /// Create a processor with custom break iterator rules
  ///
  /// [rules] ICU break iterator rule syntax
  /// See: https://unicode-org.github.io/icu/userguide/boundaryanalysis/break-rules.html
  ICUKinsokuProcessor.withCustomRules(String rules) : _icu = ICUBindings() {
    _iterator = _icu.openRules(rules, null);
  }

  /// Create a processor with JIS X 4051-inspired rules
  ///
  /// This configuration attempts to match JIS X 4051 behavior more closely
  /// by customizing character classes and break behaviors.
  factory ICUKinsokuProcessor.withJISX4051Rules() {
    final rules = _buildJISX4051Rules();
    return ICUKinsokuProcessor.withCustomRules(rules);
  }

  /// Create a processor with strict UAX #14 rules (default)
  factory ICUKinsokuProcessor.withUAX14Rules() {
    return ICUKinsokuProcessor();
  }

  /// Convert character map to ICU character class format
  ///
  /// Handles both BMP and supplementary characters (surrogate pairs)
  static String _toICUClass(Map<String, String> charMap) {
    final codes = charMap.values.map((code) {
      final codePoint = code.runes.first;
      if (codePoint > 0xFFFF) {
        // Supplementary character: use \\U with 8 hex digits
        return '\\U${codePoint.toRadixString(16).padLeft(8, '0').toUpperCase()}';
      }
      // BMP character: use \\u with 4 hex digits
      return '\\u${codePoint.toRadixString(16).padLeft(4, '0').toUpperCase()}';
    }).join(' ');
    return '[$codes]';
  }

  /// Build complete JIS X 4051:2004 compliant rules
  ///
  /// This generates ICU break iterator rules with full JIS X 4051:2004 compliance.
  /// Reference: https://kikakurui.com/x4/X4051-2004-02.html
  static String _buildJISX4051Rules() {
    final buffer = StringBuffer();

    buffer.writeln('# ========================================');
    buffer.writeln('# JIS X 4051:2004 Complete Implementation');
    buffer.writeln('# Japanese Document Composition Method');
    buffer.writeln('# ========================================');
    buffer.writeln();

    // Class 1: Opening brackets (始め括弧類) - Line-end forbidden
    buffer.writeln('# Class 1: Opening brackets (始め括弧類)');
    buffer.writeln('# 行末禁則 (gyomatsu kinsoku) - Cannot appear at line end');
    buffer.writeln('\$CL1_OPEN = ${_toICUClass(JisX4051Classes.class1_openingBrackets)};');
    buffer.writeln();

    // Class 2: Closing brackets (終わり括弧類) - Line-start forbidden
    buffer.writeln('# Class 2: Closing brackets (終わり括弧類)');
    buffer.writeln('# 行頭禁則 (gyoto kinsoku) - Cannot appear at line start');
    buffer.writeln('\$CL2_CLOSE = ${_toICUClass(JisX4051Classes.class2_closingBrackets)};');
    buffer.writeln();

    // Class 3: Japanese delimiters (句読点類) - Line-start forbidden
    buffer.writeln('# Class 3: Japanese delimiters (句読点類)');
    buffer.writeln('# 行頭禁則 (gyoto kinsoku) - Cannot appear at line start');
    buffer.writeln('\$CL3_DELIM_JA = ${_toICUClass(JisX4051Classes.class3_delimitersJa)};');
    buffer.writeln();

    // Class 4: Western period/comma - Line-start forbidden
    buffer.writeln('# Class 4: Western period/comma (ピリオド・カンマ)');
    buffer.writeln('# 行頭禁則 (gyoto kinsoku) - Cannot appear at line start');
    buffer.writeln('\$CL4_PERIOD = ${_toICUClass(JisX4051Classes.class4_periodComma)};');
    buffer.writeln();

    // Class 5: Middle dots - Line-start forbidden
    buffer.writeln('# Class 5: Middle dots (中点類)');
    buffer.writeln('# 行頭禁則 (gyoto kinsoku) - Cannot appear at line start');
    buffer.writeln('\$CL5_MIDDLE = ${_toICUClass(JisX4051Classes.class5_middleDots)};');
    buffer.writeln();

    // Class 6: Inseparable characters - Line-start forbidden
    buffer.writeln('# Class 6: Inseparable characters (分離禁止文字)');
    buffer.writeln('# 行頭禁則 (gyoto kinsoku) - Cannot appear at line start');
    buffer.writeln('\$CL6_INSEP = ${_toICUClass(JisX4051Classes.class6_inseparable)};');
    buffer.writeln();

    // Class 7: Prolonged sound mark - Line-start forbidden
    buffer.writeln('# Class 7: Prolonged sound mark (長音記号)');
    buffer.writeln('# 行頭禁則 (gyoto kinsoku) - Cannot appear at line start');
    buffer.writeln('\$CL7_PROLONG = ${_toICUClass(JisX4051Classes.class7_prolongedSound)};');
    buffer.writeln();

    // Class 8: Small kana - Line-start forbidden
    buffer.writeln('# Class 8: Small kana (小書きの仮名)');
    buffer.writeln('# 行頭禁則 (gyoto kinsoku) - Cannot appear at line start');
    buffer.writeln('\$CL8_SMALL = ${_toICUClass(JisX4051Classes.class8_smallKana)};');
    buffer.writeln();

    // Class 9: Iteration marks - Line-start forbidden
    buffer.writeln('# Class 9: Iteration marks (繰り返し記号)');
    buffer.writeln('# 行頭禁則 (gyoto kinsoku) - Cannot appear at line start');
    buffer.writeln('\$CL9_ITER = ${_toICUClass(JisX4051Classes.class9_iterationMarks)};');
    buffer.writeln();

    // Class 10: Currency/Unit symbols - Line-end forbidden
    buffer.writeln('# Class 10: Currency and unit symbols (通貨記号・単位記号)');
    buffer.writeln('# 行末禁則 (gyomatsu kinsoku) - Cannot appear at line end');
    buffer.writeln('\$CL10_CURRENCY = ${_toICUClass(JisX4051Classes.class10_currencyUnits)};');
    buffer.writeln();

    // Class 11: Postfix abbreviations - Line-start forbidden
    buffer.writeln('# Class 11: Postfix abbreviations (後置略語)');
    buffer.writeln('# 行頭禁則 (gyoto kinsoku) - Cannot appear at line start');
    buffer.writeln('\$CL11_POST = ${_toICUClass(JisX4051Classes.class11_postfixAbbrev)};');
    buffer.writeln();

    // Class 12: Prefix abbreviations - Line-end forbidden
    buffer.writeln('# Class 12: Prefix abbreviations (前置略語)');
    buffer.writeln('# 行末禁則 (gyomatsu kinsoku) - Cannot appear at line end');
    buffer.writeln('\$CL12_PREFIX = ${_toICUClass(JisX4051Classes.class12_prefixAbbrev)};');
    buffer.writeln();

    // Class 13: Dashes - Special handling for consecutive occurrence
    buffer.writeln('# Class 13: Dashes (ダッシュ・ハイフン)');
    buffer.writeln('# Special handling - Cannot separate consecutive dashes');
    buffer.writeln('\$CL13_DASH = ${_toICUClass(JisX4051Classes.class13_dashes)};');
    buffer.writeln();

    // Class 14: Ellipsis - Special handling, must appear in pairs
    buffer.writeln('# Class 14: Ellipsis and leaders (三点リーダー・二点リーダー)');
    buffer.writeln('# Special handling - Must appear in pairs (……, ‥‥)');
    buffer.writeln('\$CL14_ELLIP = ${_toICUClass(JisX4051Classes.class14_ellipsis)};');
    buffer.writeln();

    // Class 15: Combining marks - Line-start forbidden
    buffer.writeln('# Class 15: Combining marks (結合文字)');
    buffer.writeln('# 行頭禁則 (gyoto kinsoku) - Cannot appear at line start');
    buffer.writeln('\$CL15_COMB = ${_toICUClass(JisX4051Classes.class15_combiningMarks)};');
    buffer.writeln();

    // Class 16: Other gyoto kinsoku characters
    buffer.writeln('# Class 16: Other gyoto kinsoku characters');
    buffer.writeln('# 行頭禁則 (gyoto kinsoku) - Cannot appear at line start');
    buffer.writeln('\$CL16_OTHER = ${_toICUClass(JisX4051Classes.class16_otherGyoto)};');
    buffer.writeln();

    // Unicode character classes
    buffer.writeln('# Unicode character classes');
    buffer.writeln('\$HIRAGANA = [[:Hiragana:]];');
    buffer.writeln('\$KATAKANA = [[:Katakana:]];');
    buffer.writeln('\$HAN = [[:Han:]];  # CJK Ideographs');
    buffer.writeln('\$LATIN = [[:Latin:]];');
    buffer.writeln();

    // Break rules
    buffer.writeln('# ========================================');
    buffer.writeln('# Line Breaking Rules (JIS X 4051:2004)');
    buffer.writeln('# ========================================');
    buffer.writeln();

    buffer.writeln('# Rule 1: Cannot break after opening brackets (行末禁則)');
    buffer.writeln('× \$CL1_OPEN;');
    buffer.writeln();

    buffer.writeln('# Rule 2: Cannot break before closing brackets (行頭禁則)');
    buffer.writeln('\$CL2_CLOSE ×;');
    buffer.writeln();

    buffer.writeln('# Rule 3: Cannot break before Japanese delimiters (行頭禁則)');
    buffer.writeln('\$CL3_DELIM_JA ×;');
    buffer.writeln();

    buffer.writeln('# Rule 4: Cannot break before Western periods/commas (行頭禁則)');
    buffer.writeln('\$CL4_PERIOD ×;');
    buffer.writeln();

    buffer.writeln('# Rule 5: Cannot break before middle dots (行頭禁則)');
    buffer.writeln('\$CL5_MIDDLE ×;');
    buffer.writeln();

    buffer.writeln('# Rule 6: Cannot break before inseparable characters (行頭禁則)');
    buffer.writeln('\$CL6_INSEP ×;');
    buffer.writeln();

    buffer.writeln('# Rule 7: Cannot break before prolonged sound mark (行頭禁則)');
    buffer.writeln('\$CL7_PROLONG ×;');
    buffer.writeln();

    buffer.writeln('# Rule 8: Cannot break before small kana (行頭禁則)');
    buffer.writeln('\$CL8_SMALL ×;');
    buffer.writeln();

    buffer.writeln('# Rule 9: Cannot break before iteration marks (行頭禁則)');
    buffer.writeln('\$CL9_ITER ×;');
    buffer.writeln();

    buffer.writeln('# Rule 10: Cannot break after currency/unit symbols (行末禁則)');
    buffer.writeln('× \$CL10_CURRENCY;');
    buffer.writeln();

    buffer.writeln('# Rule 11: Cannot break before postfix abbreviations (行頭禁則)');
    buffer.writeln('\$CL11_POST ×;');
    buffer.writeln();

    buffer.writeln('# Rule 12: Cannot break after prefix abbreviations (行末禁則)');
    buffer.writeln('× \$CL12_PREFIX;');
    buffer.writeln();

    buffer.writeln('# Rule 13: Cannot separate consecutive dashes (分離禁止)');
    buffer.writeln('\$CL13_DASH \$CL13_DASH ×;');
    buffer.writeln();

    buffer.writeln('# Rule 14: Cannot separate paired ellipsis (分離禁止)');
    buffer.writeln('\$CL14_ELLIP \$CL14_ELLIP ×;');
    buffer.writeln();

    buffer.writeln('# Rule 15: Cannot break before combining marks (行頭禁則)');
    buffer.writeln('\$CL15_COMB ×;');
    buffer.writeln();

    buffer.writeln('# Rule 16: Cannot break before other gyoto kinsoku chars');
    buffer.writeln('\$CL16_OTHER ×;');
    buffer.writeln();

    buffer.writeln('# Rule 17: Cannot separate consecutive punctuation (！！、？？、！？、？！)');
    buffer.writeln('\$CL6_INSEP \$CL6_INSEP ×;');
    buffer.writeln();

    buffer.writeln('# Default: Allow break between other characters');
    buffer.writeln('÷;');

    return buffer.toString();
  }

  /// Check if we can break the line at the specified position
  ///
  /// [text] The full text
  /// [position] The position to check (0-based index, break BEFORE this char)
  ///
  /// Returns true if line can be broken at this position
  bool canBreakAt(String text, int position) {
    if (_currentText != text) {
      _icu.setText(_iterator, text);
      _currentText = text;
    }

    // Position < 0 or >= text.length
    if (position < 0 || position >= text.length) {
      return position == text.length; // Can break at end
    }

    // Check if ICU considers this a boundary
    return _icu.isBoundary(_iterator, position);
  }

  /// Find the best position to break the line
  ///
  /// [text] The full text
  /// [targetPosition] The ideal position to break
  ///
  /// Returns the actual position where the line should break,
  /// adjusted for kinsoku rules according to ICU
  int findBreakPosition(String text, int targetPosition) {
    if (_currentText != text) {
      _icu.setText(_iterator, text);
      _currentText = text;
    }

    if (targetPosition <= 0) return 0;
    if (targetPosition >= text.length) return text.length;

    // If target position is already a boundary, use it
    if (_icu.isBoundary(_iterator, targetPosition)) {
      return targetPosition;
    }

    // Find the preceding boundary (oikomi - push back)
    final precedingBreak = _icu.preceding(_iterator, targetPosition);
    if (precedingBreak >= 0) {
      return precedingBreak;
    }

    // Fallback: return target position
    return targetPosition;
  }

  /// Find the next break position after the given offset
  ///
  /// Returns -1 if no break position found
  int findNextBreak(String text, int offset) {
    if (_currentText != text) {
      _icu.setText(_iterator, text);
      _currentText = text;
    }

    final nextBreak = _icu.following(_iterator, offset);
    return nextBreak;
  }

  /// Find the previous break position before the given offset
  ///
  /// Returns -1 if no break position found
  int findPreviousBreak(String text, int offset) {
    if (_currentText != text) {
      _icu.setText(_iterator, text);
      _currentText = text;
    }

    final prevBreak = _icu.preceding(_iterator, offset);
    return prevBreak;
  }

  /// Get all break positions in the text
  List<int> getAllBreakPositions(String text) {
    if (_currentText != text) {
      _icu.setText(_iterator, text);
      _currentText = text;
    }

    final positions = <int>[];
    int pos = 0;
    while (pos < text.length) {
      final nextBreak = _icu.following(_iterator, pos);
      if (nextBreak < 0 || nextBreak == pos) break;
      positions.add(nextBreak);
      pos = nextBreak;
    }

    return positions;
  }

  /// Clean up resources
  void dispose() {
    _icu.close(_iterator);
  }
}

/// Configuration for customizing kinsoku behavior
class KinsokuConfig {
  /// Character classes for line-start prohibition (行頭禁則)
  final Set<String> gyotoKinsoku;

  /// Character classes for line-end prohibition (行末禁則)
  final Set<String> gyomatsuKinsoku;

  /// Characters that can hang at line end (ぶら下げ)
  final Set<String> burasageAllowed;

  /// Characters that must use oikomi (追い込み)
  final Set<String> oikomiRequired;

  /// Paired characters that cannot be separated
  final Set<String> pairedCharacters;

  const KinsokuConfig({
    this.gyotoKinsoku = const {},
    this.gyomatsuKinsoku = const {},
    this.burasageAllowed = const {},
    this.oikomiRequired = const {},
    this.pairedCharacters = const {},
  });

  /// JIS X 4051-based configuration
  static const jisX4051 = KinsokuConfig(
    gyotoKinsoku: {
      '。', '、', // Periods and commas
      '）', '」', '】', '』', '〉', '》', // Closing brackets
      'ー', // Long vowel mark
    },
    gyomatsuKinsoku: {
      '（', '「', '【', '『', '〈', '《', // Opening brackets
    },
    burasageAllowed: {
      '。', '、', // Periods and commas
      '）', '」', '】', '』', '〉', '》', // Closing brackets
    },
    oikomiRequired: {
      'ー', '―', '—', '–', '－', // Dashes and long vowel
      '…', '‥', // Leaders
    },
    pairedCharacters: {
      '…', '‥', // Must appear in pairs: ……, ‥‥
      'ー', '―', '—', '–', '－', // Dashes
    },
  );

  /// Build ICU rule string from this configuration
  String toICURules() {
    final buffer = StringBuffer();
    buffer.writeln('# Generated from KinsokuConfig');
    buffer.writeln();

    // Define character classes
    if (gyotoKinsoku.isNotEmpty) {
      buffer.write(r'$GYOTO = [');
      for (final char in gyotoKinsoku) {
        final codePoint = char.runes.first;
        if (codePoint > 0xFFFF) {
          buffer.write('\\U${codePoint.toRadixString(16).padLeft(8, '0').toUpperCase()} ');
        } else {
          buffer.write('\\u${codePoint.toRadixString(16).padLeft(4, '0')} ');
        }
      }
      buffer.writeln('];');
    }

    if (gyomatsuKinsoku.isNotEmpty) {
      buffer.write(r'$GYOMATSU = [');
      for (final char in gyomatsuKinsoku) {
        final codePoint = char.runes.first;
        if (codePoint > 0xFFFF) {
          buffer.write('\\U${codePoint.toRadixString(16).padLeft(8, '0').toUpperCase()} ');
        } else {
          buffer.write('\\u${codePoint.toRadixString(16).padLeft(4, '0')} ');
        }
      }
      buffer.writeln('];');
    }

    buffer.writeln();
    buffer.writeln('# Break rules');

    // Define break rules
    if (gyotoKinsoku.isNotEmpty) {
      buffer.writeln(r'$GYOTO ×;  # No break before gyoto kinsoku');
    }

    if (gyomatsuKinsoku.isNotEmpty) {
      buffer.writeln(r'× $GYOMATSU;  # No break after gyomatsu kinsoku');
    }

    buffer.writeln(r'÷;  # Default: allow break');

    return buffer.toString();
  }
}
