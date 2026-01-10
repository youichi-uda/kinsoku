# kinsoku

Japanese text processing library for kinsoku (禁則処理 - line breaking rules), character classification, yakumono adjustment, and kerning.

## Features

- **Kinsoku Shori (禁則処理)**: Japanese line breaking rules
  - Line-start prohibition (行頭禁則, gyoto kinsoku)
  - Line-end prohibition (行末禁則, gyomatsu kinsoku)
  - Hanging characters (ぶら下げ, burasage)
  - Pushing-in characters (追い込み, oikomi)
  - Separation prohibition for paired characters (……, ‥‥, ――, etc.)

- **Character Classification**: Identify character types
  - Kanji (漢字)
  - Hiragana (ひらがな)
  - Katakana (カタカナ)
  - Latin alphabet
  - Numbers
  - Punctuation
  - Yakumono (約物 - Japanese typography symbols)
  - Space

- **Yakumono Adjustment**: Fine-tune punctuation and symbol positioning
  - Half-width yakumono handling
  - Gyoto indent for opening brackets
  - Consecutive yakumono spacing

- **Kerning**: Spacing adjustments between character pairs
  - Kerning pairs for Japanese punctuation
  - Oikomi (push-in) adjustment calculations

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  kinsoku: ^0.1.0
```

Then run:

```bash
dart pub get
```

## Usage

### Basic Character Classification

```dart
import 'package:kinsoku/kinsoku.dart';

void main() {
  // Classify characters
  print(CharacterClassifier.classify('あ')); // CharacterType.hiragana
  print(CharacterClassifier.classify('漢')); // CharacterType.kanji
  print(CharacterClassifier.classify('A'));  // CharacterType.latin

  // Check character properties
  print(CharacterClassifier.isSmallKana('ゃ'));  // true
  print(CharacterClassifier.isLongVowelMark('ー')); // true
}
```

### Kinsoku Processing

```dart
import 'package:kinsoku/kinsoku.dart';

void main() {
  final text = 'これは禁則処理のテストです。';

  // Check if we can break at a specific position
  final canBreak = KinsokuProcessor.canBreakAt(text, 10);
  print('Can break at position 10: $canBreak');

  // Find the best break position
  final breakPos = KinsokuProcessor.findBreakPosition(text, 10);
  print('Best break position near 10: $breakPos');

  // Check if a character can hang at line end
  print(KinsokuProcessor.canHangAtLineEnd('。'));  // true
  print(KinsokuProcessor.canHangAtLineEnd('ー'));  // false
}
```

### Yakumono Adjustment

```dart
import 'package:kinsoku/kinsoku.dart';

void main() {
  // Adjust yakumono position
  final basePos = Position(100, 200);
  final adjusted = YakumonoAdjuster.adjustPosition(
    '。',
    basePos,
    fontSize: 16.0,
    adjustYakumono: true,
  );
  print('Adjusted position: (${adjusted.x}, ${adjusted.y})');

  // Check yakumono properties
  print(YakumonoAdjuster.isHalfWidthYakumono('。'));  // true
  print(YakumonoAdjuster.getYakumonoWidth('。'));     // 0.5
  print(YakumonoAdjuster.getGyotoIndent('「'));       // 0.1
}
```

### Kerning

```dart
import 'package:kinsoku/kinsoku.dart';

void main() {
  // Get kerning between two characters
  final kerning = KerningProcessor.getKerning('。', '、');
  print('Kerning between 。 and 、: $kerning');  // -0.5

  // Calculate oikomi adjustment
  final adjustment = KerningProcessor.calculateOikomiAdjustment(
    'テキスト',
    0,
    4,
    100.0,  // target width
    110.0,  // current width
  );
  print('Oikomi adjustment: $adjustment');
}
```

## Pure Dart Package

This is a **pure Dart package** with no Flutter dependencies. It can be used in:
- Flutter applications
- Web applications
- Server-side Dart applications
- Command-line tools
- Any Dart environment

## License

MIT License - see LICENSE file for details

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## References

- [JIS X 4051:2004](https://kikakurui.com/x4/X4051-2004-02.html) - Japanese document composition method
- [W3C Requirements for Japanese Text Layout (JLREQ)](https://w3c.github.io/jlreq/)
- [CSS Text Module Level 3/4](https://www.w3.org/TR/css-text-3/)
