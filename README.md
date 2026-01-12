# kinsoku

Japanese text processing library for kinsoku (禁則処理 - line breaking rules), character classification, yakumono adjustment, and kerning.

[![pub package](https://img.shields.io/pub/v/kinsoku.svg)](https://pub.dev/packages/kinsoku)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

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

- **Text Alignment**: Line-level alignment options
  - `TextAlignment.start` (天付き): Align to top/left
  - `TextAlignment.center`: Center alignment
  - `TextAlignment.end` (地付き): Align to bottom/right

## Related Packages

This package is part of the Japanese text layout suite:

| Package | Description |
|---------|-------------|
| **kinsoku** | Core text processing (this package) |
| [tategaki](https://pub.dev/packages/tategaki) | Vertical text layout (縦書き) |
| [yokogaki](https://pub.dev/packages/yokogaki) | Horizontal text layout (横書き) |

## Quick Start

シンプルな禁則処理の例:

```dart
import 'package:kinsoku/kinsoku.dart';

void main() {
  final text = 'これは禁則処理のテストです。';

  // 指定位置で改行できるか判定
  if (KinsokuProcessor.canBreakAt(text, 10)) {
    print('位置10で改行可能');
  }

  // 最適な改行位置を取得
  final breakPos = KinsokuProcessor.findBreakPosition(text, 10);
  print('推奨改行位置: $breakPos');
}
```

## Platform Support

| Platform | Pure Dart | ICU-based |
|----------|:---------:|:---------:|
| Flutter (All) | ✅ | - |
| Web | ✅ | - |
| Windows | ✅ | ✅ |
| macOS | ✅ | ✅ |
| Linux | ✅ | ✅ |
| Server | ✅ | ✅ |

**Requirements:**
- Dart SDK: ≥3.10.3
- ICU機能: ICUライブラリが必要（デスクトップ/サーバーのみ）

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  kinsoku: ^0.3.4
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

### Text Alignment

```dart
import 'package:kinsoku/kinsoku.dart';

void main() {
  // Use TextAlignment for line-level alignment
  final alignment = TextAlignment.end; // 地付き (bottom/right alignment)

  switch (alignment) {
    case TextAlignment.start:
      print('天付き - Align to start');
      break;
    case TextAlignment.center:
      print('Center alignment');
      break;
    case TextAlignment.end:
      print('地付き - Align to end');
      break;
  }
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

## ICU-based Kinsoku Processing (Optional)

For full Unicode UAX #14 compliance with customizable rules, use the ICU-based processor:

### Installation Requirements

Install the ICU library on your system:
- **macOS**: `brew install icu4c`
- **Linux**: `sudo apt install libicu-dev`
- **Windows**: Download ICU binaries from [unicode-org/icu](https://github.com/unicode-org/icu/releases)

### Usage

```dart
import 'package:kinsoku/icu.dart';

void main() {
  // Default UAX #14 rules
  final processor = ICUKinsokuProcessor();

  // Or use JIS X 4051-inspired rules
  final jisProcessor = ICUKinsokuProcessor.withJISX4051Rules();

  // Check if we can break at a position
  final text = 'これは禁則処理のテストです。';
  final canBreak = processor.canBreakAt(text, 10);

  // Find all break positions
  final breaks = processor.getAllBreakPositions(text);
  print('Break positions: $breaks');

  // Clean up
  processor.dispose();
}
```

### Custom Rules

Define custom break iterator rules using ICU syntax:

```dart
final customRules = r'''
# Define character classes
$CL_OP = [\u0028 \u300C];  # Opening brackets: （「
$CL_CL = [\u0029 \u300D];  # Closing brackets: ）」
$CL_PC = [\u3002 \u3001];  # Periods and commas: 。、

# Break rules
× $CL_OP;   # No break after opening brackets
$CL_CL ×;   # No break before closing brackets
$CL_PC ×;   # No break before periods/commas
÷;          # Default: allow break
''';

final processor = ICUKinsokuProcessor.withCustomRules(customRules);
```

### Configuration-based Rules

Use the `KinsokuConfig` class for easier customization:

```dart
final config = KinsokuConfig(
  gyotoKinsoku: {'。', '、', '）', '」'},      // Line-start forbidden
  gyomatsuKinsoku: {'（', '「'},              // Line-end forbidden
  burasageAllowed: {'。', '、'},              // Can hang
  pairedCharacters: {'…', '‥'},              // Must stay together
);

final rules = config.toICURules();
final processor = ICUKinsokuProcessor.withCustomRules(rules);
```

### ICU vs Pure Dart Comparison

| Feature | Pure Dart | ICU-based |
|---------|-----------|-----------|
| **Dependencies** | None | ICU library required |
| **Unicode Support** | Basic (hardcoded rules) | Full UAX #14 |
| **Customization** | Limited (static sets) | Extensive (custom rules) |
| **Performance** | Fast | Fast (native) |
| **Platform** | All platforms | Desktop/Server |
| **JIS X 4051 Compliance** | Simplified | **Complete (16+ classes)** |

### JIS X 4051:2004 Complete Compliance

The ICU processor provides **full compliance** with JIS X 4051:2004:

#### Complete Character Class Implementation

| Class | Description | Count | Examples |
|-------|-------------|-------|----------|
| Class 1 | Opening brackets (始め括弧類) | 14 | （「『【〈《〔 |
| Class 2 | Closing brackets (終わり括弧類) | 14 | ）」』】〉》〕 |
| Class 3 | Japanese delimiters (句読点類) | 4 | 。、，． |
| Class 4 | Western period/comma | 2 | ,. |
| Class 5 | Middle dots (中点類) | 5 | ・：；: ; |
| Class 6 | Inseparable chars (分離禁止) | 4 | ！？!? |
| Class 7 | Prolonged sound (長音記号) | 1 | ー |
| Class 8 | Small kana (小書き仮名) | 24 | ぁぃぅぇぉゃゅょゎっァィゥェォャュョヮッ |
| Class 9 | Iteration marks (繰返記号) | 7 | ゝゞヽヾ々〃〻 |
| Class 10 | Currency/units (通貨・単位) | 11 | $¥£€℃°% |
| Class 11 | Postfix abbreviations | 5 | ℃°′″℉ |
| Class 12 | Prefix abbreviations | 3 | №＃# |
| Class 13 | Dashes (ダッシュ) | 10 | ‐–—―－─ |
| Class 14 | Ellipsis (リーダー) | 3 | …‥⋯ |
| Class 15 | Combining marks | 2 | ゛゜ |
| Class 16+ | Other special chars | Various | 〳〴〵ヿ |

#### Line Breaking Rules

- **Gyoto Kinsoku** (行頭禁則): 70+ characters cannot appear at line start
- **Gyomatsu Kinsoku** (行末禁則): 25+ characters cannot appear at line end
- **Paired Separation** (分離禁止): ……, ‥‥, ――, etc. must stay together
- **Consecutive Punctuation**: ！！, ？？, ！？, ？！ cannot be separated
- **Special Handling**: Currency symbols (¥£€), small kana, iteration marks

See `example/icu_example.dart` for comprehensive examples.

## Use Cases / ユースケース

### テキストエディタの改行処理

ユーザー入力テキストの自動改行:

```dart
String wrapText(String text, int maxCharsPerLine) {
  final lines = <String>[];
  var remaining = text;

  while (remaining.isNotEmpty) {
    if (remaining.length <= maxCharsPerLine) {
      lines.add(remaining);
      break;
    }

    // 禁則を考慮した改行位置を取得
    final breakPos = KinsokuProcessor.findBreakPosition(
      remaining,
      maxCharsPerLine,
    );

    lines.add(remaining.substring(0, breakPos));
    remaining = remaining.substring(breakPos);
  }

  return lines.join('\n');
}
```

### 文字種判定

入力バリデーションやIME処理:

```dart
bool isJapaneseText(String text) {
  for (final char in text.characters) {
    final type = CharacterClassifier.classify(char);
    if (type == CharacterType.hiragana ||
        type == CharacterType.katakana ||
        type == CharacterType.kanji) {
      return true;
    }
  }
  return false;
}
```

### DTPソフトウェア

プロフェッショナルな組版処理:

```dart
// JIS X 4051準拠の禁則処理（ICU使用）
final processor = ICUKinsokuProcessor.withJISX4051Rules();

// テキストの全改行位置を取得
final breaks = processor.getAllBreakPositions(text);

// カスタムルールで初期化
final config = KinsokuConfig(
  gyotoKinsoku: {'。', '、', '）', '」'},
  gyomatsuKinsoku: {'（', '「'},
  burasageAllowed: {'。', '、'},
);
final customProcessor = ICUKinsokuProcessor.withCustomRules(
  config.toICURules(),
);
```

### カーニング調整

約物間のスペース最適化:

```dart
double calculateLineWidth(String line, double fontSize) {
  double width = 0;
  for (var i = 0; i < line.length; i++) {
    width += fontSize;
    if (i < line.length - 1) {
      // 約物間のカーニング値を取得
      final kerning = KerningProcessor.getKerning(
        line[i],
        line[i + 1],
      );
      width += kerning * fontSize;
    }
  }
  return width;
}
```

## Pure Dart Package

This is a **pure Dart package** with no Flutter dependencies. The core functionality works everywhere:
- Flutter applications
- Web applications
- Server-side Dart applications
- Command-line tools
- Any Dart environment

The ICU-based processor requires native ICU library and works on:
- macOS, Linux, Windows (desktop)
- Server environments
- (Not available on web or mobile platforms)

## License

MIT License - see LICENSE file for details

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## References

- [JIS X 4051:2004](https://kikakurui.com/x4/X4051-2004-02.html) - Japanese document composition method
- [W3C Requirements for Japanese Text Layout (JLREQ)](https://w3c.github.io/jlreq/)
- [CSS Text Module Level 3/4](https://www.w3.org/TR/css-text-3/)
