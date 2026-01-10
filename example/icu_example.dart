import 'package:kinsoku/icu.dart';

/// Examples of using ICU-based kinsoku processor
///
/// To run this example, ensure ICU is installed:
/// - macOS: brew install icu4c
/// - Linux: sudo apt install libicu-dev
/// - Windows: Download ICU binaries from https://github.com/unicode-org/icu/releases
void main() {
  print('=== ICU-based Kinsoku Processing Examples ===\n');

  // Example 1: Default UAX #14 rules
  example1_defaultRules();

  // Example 2: JIS X 4051-inspired rules
  example2_jisX4051Rules();

  // Example 3: Custom rules
  example3_customRules();

  // Example 4: Configuration-based rules
  example4_configBasedRules();

  // Example 5: Finding all break positions
  example5_allBreakPositions();

  // Example 6: Comparing different rule sets
  example6_compareRuleSets();
}

void example1_defaultRules() {
  print('--- Example 1: Default UAX #14 Rules ---');

  try {
    final processor = ICUKinsokuProcessor();
    final text = 'これは禁則処理のテストです。改行位置を確認します。';

    print('Text: $text');
    print('Length: ${text.length}');

    // Check specific positions
    for (int i = 0; i < text.length; i += 5) {
      final canBreak = processor.canBreakAt(text, i);
      final char = i < text.length ? text[i] : '(end)';
      print('Position $i ($char): ${canBreak ? "✓ Can break" : "✗ Cannot break"}');
    }

    processor.dispose();
  } catch (e) {
    print('Error: $e');
    print('Make sure ICU library is installed.');
  }

  print('');
}

void example2_jisX4051Rules() {
  print('--- Example 2: JIS X 4051-inspired Rules ---');

  try {
    final processor = ICUKinsokuProcessor.withJISX4051Rules();
    final testCases = [
      'テキスト。',
      '（開始）',
      '終了）',
      'テスト……',
      '質問？！',
    ];

    for (final text in testCases) {
      print('\nText: $text');
      for (int i = 0; i <= text.length; i++) {
        final canBreak = processor.canBreakAt(text, i);
        final char = i < text.length ? text[i] : '(end)';
        if (!canBreak && i < text.length) {
          print('  Position $i ($char): ✗ Cannot break (kinsoku)');
        }
      }
    }

    processor.dispose();
  } catch (e) {
    print('Error: $e');
  }

  print('');
}

void example3_customRules() {
  print('--- Example 3: Custom Rules ---');

  try {
    // Define custom rules focusing only on basic punctuation
    final customRules = r'''
# Custom rules for Japanese punctuation
$PERIOD = [\u3002];  # 。
$COMMA = [\u3001];   # 、
$OPEN = [\u300C];    # 「
$CLOSE = [\u300D];   # 」

# Break rules
$PERIOD ×;   # No break before period
$COMMA ×;    # No break before comma
× $OPEN;     # No break after opening quote
$CLOSE ×;    # No break before closing quote

÷;  # Default: allow break
''';

    final processor = ICUKinsokuProcessor.withCustomRules(customRules);
    final text = 'これは「カスタムルール」です。';

    print('Text: $text');
    print('Custom rules applied.');

    final breaks = processor.getAllBreakPositions(text);
    print('Break positions: $breaks');

    processor.dispose();
  } catch (e) {
    print('Error: $e');
  }

  print('');
}

void example4_configBasedRules() {
  print('--- Example 4: Configuration-based Rules ---');

  try {
    // Create custom configuration
    final config = KinsokuConfig(
      gyotoKinsoku: {'。', '、', '）', '」'},
      gyomatsuKinsoku: {'（', '「'},
      burasageAllowed: {'。', '、'},
      pairedCharacters: {'…', '‥'},
    );

    // Generate ICU rules from configuration
    final rules = config.toICURules();
    print('Generated rules:');
    print(rules);

    final processor = ICUKinsokuProcessor.withCustomRules(rules);
    final text = 'テキスト（例）です。';

    print('\nText: $text');
    final breakPos = processor.findBreakPosition(text, 8);
    print('Best break position near 8: $breakPos');

    processor.dispose();
  } catch (e) {
    print('Error: $e');
  }

  print('');
}

void example5_allBreakPositions() {
  print('--- Example 5: Finding All Break Positions ---');

  try {
    final processor = ICUKinsokuProcessor();
    final text = '日本語の文章を複数の行に分割します。改行位置を自動的に検出します。';

    print('Text: $text');
    print('Length: ${text.length}');

    final breaks = processor.getAllBreakPositions(text);
    print('\nAll break positions: $breaks');
    print('Total breaks: ${breaks.length}');

    // Show text segments
    print('\nText segments:');
    int start = 0;
    for (final breakPos in breaks) {
      final segment = text.substring(start, breakPos);
      print('  [$start-$breakPos]: "$segment"');
      start = breakPos;
    }

    processor.dispose();
  } catch (e) {
    print('Error: $e');
  }

  print('');
}

void example6_compareRuleSets() {
  print('--- Example 6: Comparing Different Rule Sets ---');

  try {
    final text = 'これは比較テストです。／スラッシュや€ユーロ記号の扱い。';

    print('Text: $text');
    print('');

    // UAX #14 (default)
    final uax14 = ICUKinsokuProcessor();
    final uax14Breaks = uax14.getAllBreakPositions(text);
    print('UAX #14 breaks: $uax14Breaks');
    uax14.dispose();

    // JIS X 4051
    final jis = ICUKinsokuProcessor.withJISX4051Rules();
    final jisBreaks = jis.getAllBreakPositions(text);
    print('JIS X 4051 breaks: $jisBreaks');
    jis.dispose();

    // Compare
    print('\nDifferences:');
    final uax14Set = Set<int>.from(uax14Breaks);
    final jisSet = Set<int>.from(jisBreaks);

    final onlyInUax14 = uax14Set.difference(jisSet);
    final onlyInJis = jisSet.difference(uax14Set);

    if (onlyInUax14.isNotEmpty) {
      print('Only in UAX #14: $onlyInUax14');
    }
    if (onlyInJis.isNotEmpty) {
      print('Only in JIS X 4051: $onlyInJis');
    }
    if (onlyInUax14.isEmpty && onlyInJis.isEmpty) {
      print('No differences for this text.');
    }
  } catch (e) {
    print('Error: $e');
  }

  print('');
}
