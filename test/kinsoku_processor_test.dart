import 'package:test/test.dart';
import 'package:kinsoku/kinsoku.dart';

void main() {
  group('KinsokuProcessor', () {
    test('allows breaking before normal characters', () {
      expect(KinsokuProcessor.canBreakAt('あいう', 0), true);
      expect(KinsokuProcessor.canBreakAt('あいう', 1), true);
      expect(KinsokuProcessor.canBreakAt('あいう', 2), true);
    });

    test('disallows breaking before gyoto kinsoku characters', () {
      // Cannot break before 。
      expect(KinsokuProcessor.canBreakAt('あ。い', 1), false);
      // Cannot break before 、
      expect(KinsokuProcessor.canBreakAt('あ、い', 1), false);
      // Cannot break before ）
      expect(KinsokuProcessor.canBreakAt('あ）い', 1), false);
      // Cannot break before 」
      expect(KinsokuProcessor.canBreakAt('あ」い', 1), false);
    });

    test('disallows breaking after gyomatsu kinsoku characters', () {
      // Cannot break after （
      expect(KinsokuProcessor.canBreakAt('あ（い', 2), false);
      // Cannot break after 「
      expect(KinsokuProcessor.canBreakAt('あ「い', 2), false);
    });

    test('handles inseparable pairs', () {
      // Two ellipses should not be separated (between the two ellipses)
      expect(KinsokuProcessor.canBreakAt('あ……い', 2), false);
      // Can break after the pair of ellipses
      expect(KinsokuProcessor.canBreakAt('あ……い', 3), true);
      // Single ellipsis can have a break after it
      expect(KinsokuProcessor.canBreakAt('あ…い', 2), true);
    });

    test('finds proper break position', () {
      final text = 'これは文章。次の文';
      // Position 6 (after 。) is valid - splits into 'これは文章。' and '次の文'
      final breakPos1 = KinsokuProcessor.findBreakPosition(text, 6);
      expect(breakPos1, 6); // Can break here

      // Position 5 (before 。) cannot break - 。 would be at line start
      final breakPos2 = KinsokuProcessor.findBreakPosition(text, 5);
      expect(breakPos2, lessThan(5)); // Must move back
    });

    test('handles edge cases', () {
      // Empty string
      expect(KinsokuProcessor.canBreakAt('', 0), true);

      // Single character
      expect(KinsokuProcessor.canBreakAt('あ', 0), true);

      // At end of string
      expect(KinsokuProcessor.canBreakAt('あいう', 3), true);
    });

    test('disallows breaking between consecutive punctuation', () {
      // Full-width: Cannot break between ！！
      expect(KinsokuProcessor.canBreakAt('驚き！！', 3), false);
      // Full-width: Cannot break between ？？
      expect(KinsokuProcessor.canBreakAt('本当？？', 3), false);
      // Full-width: Cannot break between ！？
      expect(KinsokuProcessor.canBreakAt('何！？', 2), false);
      // Full-width: Cannot break between ？！
      expect(KinsokuProcessor.canBreakAt('えっ？！', 3), false);

      // Half-width: Cannot break between !!
      expect(KinsokuProcessor.canBreakAt('驚き!!', 3), false);
      // Half-width: Cannot break between ??
      expect(KinsokuProcessor.canBreakAt('本当??', 3), false);
      // Half-width: Cannot break between !?
      expect(KinsokuProcessor.canBreakAt('何!?', 2), false);
      // Half-width: Cannot break between ?!
      expect(KinsokuProcessor.canBreakAt('えっ?!', 3), false);
    });

    test('identifies small characters that can hang', () {
      // Small punctuation can hang
      expect(KinsokuProcessor.canHangAtLineEnd('。'), true);
      expect(KinsokuProcessor.canHangAtLineEnd('、'), true);

      // Closing brackets can hang
      expect(KinsokuProcessor.canHangAtLineEnd('）'), true);
      expect(KinsokuProcessor.canHangAtLineEnd('」'), true);

      // Full-size punctuation cannot hang (not in burasageAllowed)
      expect(KinsokuProcessor.canHangAtLineEnd('！'), false);
      expect(KinsokuProcessor.canHangAtLineEnd('？'), false);
      expect(KinsokuProcessor.canHangAtLineEnd('!'), false);
      expect(KinsokuProcessor.canHangAtLineEnd('?'), false);
      expect(KinsokuProcessor.canHangAtLineEnd('…'), false);
    });

    test('identifies characters that must use oikomi', () {
      // Leaders and dashes must use oikomi (cannot hang)
      expect(KinsokuProcessor.mustUseOikomi('…'), true);
      expect(KinsokuProcessor.mustUseOikomi('‥'), true);
      expect(KinsokuProcessor.mustUseOikomi('ー'), true);
      expect(KinsokuProcessor.mustUseOikomi('―'), true);

      // Small punctuation does not require oikomi (can hang)
      expect(KinsokuProcessor.mustUseOikomi('。'), false);
      expect(KinsokuProcessor.mustUseOikomi('、'), false);

      // Closing brackets do not require oikomi (can hang)
      expect(KinsokuProcessor.mustUseOikomi('）'), false);
      expect(KinsokuProcessor.mustUseOikomi('」'), false);

      // Full-width punctuation marks are not in burasageForbidden
      expect(KinsokuProcessor.mustUseOikomi('！'), false);
      expect(KinsokuProcessor.mustUseOikomi('？'), false);
    });
  });
}
