/// Japanese text processing library for kinsoku (line breaking rules),
/// character classification, yakumono adjustment, and kerning.
///
/// This library provides core Japanese typography functionality including:
/// - Kinsoku shori (禁則処理): Line breaking rules for Japanese text
/// - Character classification: Identifying kanji, hiragana, katakana, etc.
/// - Yakumono adjustment: Fine-tuning punctuation and symbol positions
/// - Kerning: Spacing adjustments between character pairs
library kinsoku;

export 'src/kinsoku_processor.dart';
export 'src/character_classifier.dart';
export 'src/yakumono_adjuster.dart';
export 'src/kerning_processor.dart';
export 'src/models/character_type.dart';
export 'src/models/position.dart';
export 'src/models/text_alignment.dart';
