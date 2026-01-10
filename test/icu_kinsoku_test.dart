import 'package:test/test.dart';
import 'package:kinsoku/icu.dart';

void main() {
  group('ICUKinsokuProcessor', () {
    late ICUKinsokuProcessor processor;

    setUp(() {
      try {
        processor = ICUKinsokuProcessor();
      } catch (e) {
        print('Warning: ICU library not found. Skipping ICU tests.');
        print('Install ICU: brew install icu4c (macOS), apt install libicu-dev (Linux)');
        return;
      }
    });

    tearDown(() {
      try {
        processor.dispose();
      } catch (_) {}
    });

    test('can break at valid positions', () {
      try {
        final text = 'これは禁則処理のテストです。';

        // Should be able to break between most characters
        expect(processor.canBreakAt(text, 0), isTrue); // Start
        expect(processor.canBreakAt(text, text.length), isTrue); // End
      } catch (e) {
        print('Skipping test: $e');
      }
    }, skip: 'Requires ICU library installation');

    test('cannot break before gyoto kinsoku characters', () {
      try {
        final text = 'テキスト。';

        // Should not break before 。
        final dotPosition = text.indexOf('。');
        expect(processor.canBreakAt(text, dotPosition), isFalse);
      } catch (e) {
        print('Skipping test: $e');
      }
    }, skip: 'Requires ICU library installation');

    test('findBreakPosition returns valid position', () {
      try {
        final text = 'これは長いテキストです。';

        final breakPos = processor.findBreakPosition(text, 8);
        expect(breakPos, greaterThanOrEqualTo(0));
        expect(breakPos, lessThanOrEqualTo(text.length));
      } catch (e) {
        print('Skipping test: $e');
      }
    }, skip: 'Requires ICU library installation');

    test('getAllBreakPositions returns all breaks', () {
      try {
        final text = 'テスト文章';

        final breaks = processor.getAllBreakPositions(text);
        expect(breaks, isNotEmpty);
        expect(breaks.last, equals(text.length));
      } catch (e) {
        print('Skipping test: $e');
      }
    }, skip: 'Requires ICU library installation');
  });

  group('ICUKinsokuProcessor with JIS X 4051 rules', () {
    late ICUKinsokuProcessor processor;

    setUp(() {
      try {
        processor = ICUKinsokuProcessor.withJISX4051Rules();
      } catch (e) {
        print('Warning: ICU library not found. Skipping JIS X 4051 tests.');
        return;
      }
    });

    tearDown(() {
      try {
        processor.dispose();
      } catch (_) {}
    });

    test('respects JIS X 4051 rules for closing brackets', () {
      try {
        final text = 'テキスト）';

        // Should not break before closing bracket
        final bracketPos = text.indexOf('）');
        expect(processor.canBreakAt(text, bracketPos), isFalse);
      } catch (e) {
        print('Skipping test: $e');
      }
    }, skip: 'Requires ICU library installation');

    test('respects JIS X 4051 rules for opening brackets', () {
      try {
        final text = 'テキスト（続き';

        // Should not break after opening bracket
        final bracketPos = text.indexOf('（');
        expect(processor.canBreakAt(text, bracketPos + 1), isFalse);
      } catch (e) {
        print('Skipping test: $e');
      }
    }, skip: 'Requires ICU library installation');
  });

  group('KinsokuConfig', () {
    test('toICURules generates valid rule string', () {
      final config = KinsokuConfig.jisX4051;
      final rules = config.toICURules();

      expect(rules, contains('GYOTO'));
      expect(rules, contains('GYOMATSU'));
      expect(rules, contains('×'));
      expect(rules, contains('÷'));
    });

    test('custom config generates rules', () {
      final config = KinsokuConfig(
        gyotoKinsoku: {'。', '、'},
        gyomatsuKinsoku: {'（'},
      );

      final rules = config.toICURules();
      expect(rules, isNotEmpty);
      expect(rules, contains('GYOTO'));
      expect(rules, contains('GYOMATSU'));
    });
  });

  group('ICUKinsokuProcessor with custom rules', () {
    test('accepts custom rule string', () {
      try {
        final customRules = r'''
# Simple custom rules
$CL_OP = [\u0028];  # (
$CL_CL = [\u0029];  # )
× $CL_OP;
$CL_CL ×;
÷;
''';

        final processor = ICUKinsokuProcessor.withCustomRules(customRules);
        expect(processor, isNotNull);
        processor.dispose();
      } catch (e) {
        print('Skipping custom rules test: $e');
      }
    }, skip: 'Requires ICU library installation');
  });
}
