# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-01-10

### Added
- Initial release of kinsoku package
- `KinsokuProcessor`: Japanese line breaking rules (kinsoku shori)
  - Line-start and line-end prohibition
  - Hanging (burasage) and pushing-in (oikomi) support
  - Separation prohibition for paired characters
- `CharacterClassifier`: Character type identification
  - Support for kanji, hiragana, katakana, latin, numbers, punctuation, yakumono, space
  - Helper methods for small kana, long vowel marks, brackets
- `YakumonoAdjuster`: Yakumono position and spacing adjustment
  - Half-width yakumono handling
  - Gyoto indent for opening brackets
  - Consecutive yakumono spacing
- `KerningProcessor`: Kerning and spacing adjustments
  - Kerning pairs for Japanese punctuation
  - Oikomi adjustment calculations
- `Position`: Pure Dart 2D position class (alternative to Flutter's Offset)
- `CharacterType`: Enum for character classification

### Notes
- This is a pure Dart package with no Flutter dependencies
- Extracted from the [tategaki](https://pub.dev/packages/tategaki) package for broader reusability
