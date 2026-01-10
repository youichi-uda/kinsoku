# tategaki パッケージとの統合ガイド

このガイドでは、ICU-based kinsoku processorを`tategaki`パッケージと統合する方法を説明します。

## 概要

`tategaki`パッケージは現在、独自実装の`KinsokuProcessor`を使用しています。ICUベースの実装を使用することで、以下のメリットがあります：

1. **UAX #14完全準拠**: Unicode標準の改行アルゴリズムに準拠
2. **カスタマイズ可能**: ルールを柔軟にカスタマイズ可能
3. **JIS X 4051対応**: 日本の工業規格に近い動作も選択可能

## 統合方法

### オプション1: KinsokuProcessorインターフェースの実装

`text_layouter.dart`で使用されている`KinsokuProcessor`の代わりに、ICU版を使用できるようにします。

#### 1. kinsoku/src/kinsoku_interface.dart を作成

```dart
/// Abstract interface for kinsoku processors
abstract class IKinsokuProcessor {
  bool canBreakAt(String text, int position);
  int findBreakPosition(String text, int targetPosition);
  bool canHangAtLineEnd(String char);
}
```

#### 2. 既存のKinsokuProcessorをラップ

```dart
// kinsoku/src/kinsoku_processor_impl.dart
class KinsokuProcessorImpl implements IKinsokuProcessor {
  @override
  bool canBreakAt(String text, int position) {
    return KinsokuProcessor.canBreakAt(text, position);
  }

  @override
  int findBreakPosition(String text, int targetPosition) {
    return KinsokuProcessor.findBreakPosition(text, targetPosition);
  }

  @override
  bool canHangAtLineEnd(String char) {
    return KinsokuProcessor.canHangAtLineEnd(char);
  }
}
```

#### 3. ICU版の実装を追加

```dart
// kinsoku/src/icu/icu_kinsoku_processor_adapter.dart
import '../kinsoku_interface.dart';
import 'icu_kinsoku_processor.dart';

class ICUKinsokuProcessorAdapter implements IKinsokuProcessor {
  final ICUKinsokuProcessor _processor;

  ICUKinsokuProcessorAdapter(this._processor);

  factory ICUKinsokuProcessorAdapter.withUAX14() {
    return ICUKinsokuProcessorAdapter(ICUKinsokuProcessor());
  }

  factory ICUKinsokuProcessorAdapter.withJISX4051() {
    return ICUKinsokuProcessorAdapter(
      ICUKinsokuProcessor.withJISX4051Rules()
    );
  }

  @override
  bool canBreakAt(String text, int position) {
    return _processor.canBreakAt(text, position);
  }

  @override
  int findBreakPosition(String text, int targetPosition) {
    return _processor.findBreakPosition(text, targetPosition);
  }

  @override
  bool canHangAtLineEnd(String char) {
    // ICU doesn't have direct "can hang" concept
    // We need to determine this based on character properties
    // For now, use the same logic as the pure Dart version
    const burasageAllowed = {'。', '、', '）', '」', '】', '』', '〉', '》'};
    return burasageAllowed.contains(char);
  }

  void dispose() {
    _processor.dispose();
  }
}
```

### オプション2: VerticalTextStyleでプロセッサを選択可能にする

#### 1. VerticalTextStyleにプロセッサ設定を追加

```dart
// tategaki/lib/src/models/vertical_text_style.dart
class VerticalTextStyle {
  // ... existing fields ...

  /// Kinsoku processor to use (null = use default)
  final IKinsokuProcessor? kinsokuProcessor;

  const VerticalTextStyle({
    // ... existing parameters ...
    this.kinsokuProcessor,
  });
}
```

#### 2. TextLayouterで使用

```dart
// tategaki/lib/src/rendering/text_layouter.dart
class TextLayouter {
  List<CharacterLayout> layoutText(
    String text,
    VerticalTextStyle style,
    double maxHeight, {
    // ...
  }) {
    final kinsoku = style.kinsokuProcessor ?? KinsokuProcessorImpl();

    // ... layout logic ...

    // Use kinsoku.canBreakAt() instead of KinsokuProcessor.canBreakAt()
    if (!kinsoku.canBreakAt(text, i)) {
      // Handle kinsoku
    }
  }
}
```

#### 3. 使用例

```dart
import 'package:tategaki/tategaki.dart';
import 'package:kinsoku/icu.dart';

void main() {
  // ICU-based kinsoku with JIS X 4051 rules
  final icuProcessor = ICUKinsokuProcessorAdapter.withJISX4051();

  final style = VerticalTextStyle(
    baseStyle: TextStyle(fontSize: 16),
    kinsokuProcessor: icuProcessor,
  );

  final widget = VerticalText(
    'これは縦書きテキストです。ICUベースの禁則処理を使用します。',
    style: style,
  );

  // Don't forget to dispose when done
  icuProcessor.dispose();
}
```

### オプション3: グローバル設定

アプリケーション全体でデフォルトのプロセッサを設定する方法：

```dart
// tategaki/lib/src/config/kinsoku_config.dart
class TategakiConfig {
  static IKinsokuProcessor? _defaultProcessor;

  static void setDefaultKinsokuProcessor(IKinsokuProcessor processor) {
    _defaultProcessor = processor;
  }

  static IKinsokuProcessor getDefaultKinsokuProcessor() {
    return _defaultProcessor ?? KinsokuProcessorImpl();
  }
}
```

使用例：

```dart
void main() {
  // アプリケーション起動時に設定
  TategakiConfig.setDefaultKinsokuProcessor(
    ICUKinsokuProcessorAdapter.withJISX4051()
  );

  runApp(MyApp());
}
```

## カスタムルールの例

### JIS X 4051に完全準拠するカスタムルール

```dart
final customRules = r'''
# JIS X 4051 Class definitions
# Class 1: Opening brackets (始め括弧類)
$CL1 = [\u0028 \u005B \u007B \u3014 \u300C \u300E \u3010 \u3008 \u300A];

# Class 2: Closing brackets (終わり括弧類)
$CL2 = [\u0029 \u005D \u007D \u3015 \u300D \u300F \u3011 \u3009 \u300B];

# Class 3: Cannot start line (行頭禁則和字)
$CL3 = [\u3002 \u3001 \uFF0C \uFF0E];  # 。、，．

# Class 4: Cannot start line (行頭禁則欧文)
$CL4 = [\u0021 \u003F \uFF01 \uFF1F];  # !?！？

# Class 5: Middle dots
$CL5 = [\u30FB \u003A \u003B];  # ・:;

# Class 6: Long vowel mark
$CL6 = [\u30FC];  # ー

# Class 7: Small kana
$CL7 = [\u3041 \u3043 \u3045 \u3047 \u3049 \u3063 \u3083 \u3085 \u3087 \u308E
        \u30A1 \u30A3 \u30A5 \u30A7 \u30A9 \u30C3 \u30E3 \u30E5 \u30E7 \u30EE];

# Class 8: Cannot end line (行末禁則和字)
# (Opening brackets from CL1)

# Class 9: Cannot end line (行末禁則欧文)
$CL9 = [\u0024 \u00A3 \u00A5];  # $£¥

# Class 10: Cannot be separated
$CL10 = [\u2026 \u2025];  # …‥

# Break rules
× $CL1;        # No break after opening brackets
$CL2 ×;        # No break before closing brackets
$CL3 ×;        # No break before periods/commas
$CL4 ×;        # No break before !?
$CL5 ×;        # No break before middle dots
$CL6 ×;        # No break before long vowel
$CL7 ×;        # No break before small kana
$CL9 ×;        # No break after currency symbols
$CL10 $CL10 ×; # Cannot separate paired characters

÷;  # Default: allow break
''';

final processor = ICUKinsokuProcessor.withCustomRules(customRules);
```

## 性能比較

| プロセッサ | 初期化 | 処理速度 | メモリ | プラットフォーム |
|-----------|--------|---------|--------|-----------------|
| Pure Dart | 即座 | 高速 | 低 | すべて |
| ICU (UAX #14) | やや遅い | 高速 | 中 | Desktop/Server |
| ICU (カスタム) | やや遅い | 高速 | 中 | Desktop/Server |

## トラブルシューティング

### ICU libraryが見つからない

```
Error: ICU library not found on macOS. Install via: brew install icu4c
```

**解決方法:**
- macOS: `brew install icu4c`
- Linux: `sudo apt install libicu-dev`
- Windows: ICUバイナリをダウンロードしてPATHに追加

### カスタムルールのパースエラー

```
Exception: ICU error: 1, parse error at: 42
```

**解決方法:**
- ルール構文を確認（ICU Break Iterator Rule Syntax）
- Unicode escape sequence: `\uXXXX` (4桁の16進数)
- 文字クラス定義: `$VAR = [chars];`
- Break rules: `×` (禁則), `÷` (許可)

## 参考資料

- [ICU Break Iterator Rules](https://unicode-org.github.io/icu/userguide/boundaryanalysis/break-rules.html)
- [UAX #14: Unicode Line Breaking Algorithm](https://www.unicode.org/reports/tr14/)
- [JIS X 4051:2004](https://kikakurui.com/x4/X4051-2004-02.html)
- [W3C JLREQ](https://w3c.github.io/jlreq/)
