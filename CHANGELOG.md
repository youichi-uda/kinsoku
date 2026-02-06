# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.7] - 2026-02-06

### Fixed
- **Missing quotation marks in kinsoku rules**: Add 8 quotation mark characters per JIS X 4051 / JLREQ
  - Opening (行末禁則): `'` (U+2018), `"` (U+201C), `«` (U+00AB), `〝` (U+301D)
  - Closing (行頭禁則): `'` (U+2019), `"` (U+201D), `»` (U+00BB), `〟` (U+301F)
  - Updated `JisX4051Classes` (class1/class2), `KinsokuProcessor`, and `CharacterClassifier`

## [0.3.6] - 2026-02-02

### Fixed
- **ICU rule generation**: Fix `codeUnitAt(0)` → `runes.first` for proper Unicode support in `KinsokuConfig.toICURules()`
  - Characters outside BMP (CJK Extension B-G) now generate correct ICU rules with `\U` escape
- **ICU library loading**: Capture and display last error when library loading fails for better debugging

## [0.3.5] - 2026-01-12

### Changed
- **CharacterClassifier**: Use `runes.first` for proper surrogate pair support (CJK Extension B-G)
- **CharacterClassifier**: Add full-width number (０-９) and alphabet (Ａ-Ｚ, ａ-ｚ) classification
- **CharacterClassifier**: Add missing small kana (ゕ, ゖ, ヵ, ヶ)
- **CharacterClassifier**: Optimize constants to static const for better performance
- **YakumonoAdjuster**: Reuse CharacterClassifier methods to eliminate code duplication
- **KerningProcessor**: Simplify getKerning with null-aware operators
- **ICUKinsokuProcessor**: Extract `_toICUClass` as static method with surrogate pair support
- **JisX4051Classes**: Cache getAllGyotoKinsoku/getAllGyomatsuKinsoku results for performance
- **JisX4051Classes**: Fix duplicate ℃/° entries between class 10 and 11

## [0.3.4] - 2026-01-11

### Added
- Quick Start section with Japanese examples
- Platform Support table (Pure Dart vs ICU-based)
- Use Cases section with practical code examples

## [0.3.3] - 2026-01-11

### Changed
- Updated README with TextAlignment documentation and usage examples
- Added Related Packages section linking to tategaki and yokogaki
- Added pub.dev and license badges

## [0.3.2] - 2026-01-11

### Fixed
- Added library declaration to jis_x_4051_classes.dart to fix dangling doc comment lint

## [0.3.1] - 2026-01-11

### Fixed
- Added `non_constant_identifier_names` ignore for FFI bindings (ICU function names)

## [0.3.0] - 2026-01-11

### Added
- **TextAlignment enum** for line-level text alignment
  - `start` (天付き): Align to top (vertical) or left (horizontal)
  - `center`: Center alignment (default)
  - `end` (地付き): Align to bottom (vertical) or right (horizontal)

### Changed
- Exported TextAlignment from kinsoku.dart for use in tategaki/yokogaki packages

## [0.2.0] - 2026-01-10

### Added
- **Complete JIS X 4051:2004 compliance** with all 16+ character classes
- Full-width bracket support (（）［］｛｝)
- Enhanced character class definitions for comprehensive Japanese typography

### Fixed
- ICU bindings memory management (proper calloc usage)
- Character class test coverage
- Missing full-width brackets in JIS X 4051 classes

### Changed
- Improved FFI memory handling to prevent leaks
- Updated documentation with complete character class tables

## [0.1.0] - 2026-01-10

### Added

#### Core Features (Pure Dart)
- `KinsokuProcessor`: Japanese line breaking rules (kinsoku shori)
  - Line-start prohibition (行頭禁則, gyoto kinsoku)
  - Line-end prohibition (行末禁則, gyomatsu kinsoku)
  - Hanging characters (ぶら下げ, burasage) support
  - Pushing-in characters (追い込み, oikomi) support
  - Separation prohibition for paired characters (……, ‥‥, ――, etc.)
- `CharacterClassifier`: Character type identification
  - Support for kanji, hiragana, katakana, latin, numbers, punctuation, yakumono, space
  - Helper methods for small kana, long vowel marks, brackets
  - Iteration mark detection
- `YakumonoAdjuster`: Yakumono (約物) position and spacing adjustment
  - Half-width yakumono handling
  - Gyoto indent for opening brackets
  - Consecutive yakumono spacing adjustments
  - Vertical glyph support
- `KerningProcessor`: Kerning and spacing adjustments
  - Kerning pairs for Japanese punctuation
  - Oikomi adjustment calculations
- `Position`: Pure Dart 2D position class (alternative to Flutter's Offset)
- `CharacterType`: Enum for character classification

#### ICU-based Features (Optional)
- **Complete JIS X 4051:2004 compliance** ✨
  - `ICUKinsokuProcessor`: ICU break iterator-based line breaking
  - Full UAX #14 (Unicode Line Breaking Algorithm) support
  - Complete implementation of all 16+ JIS X 4051 character classes
  - `JisX4051Classes`: Comprehensive character class definitions
    - Class 1-2: Opening/Closing brackets (28+ characters)
    - Class 3-6: Delimiters and punctuation (15+ characters)
    - Class 7-9: Prolonged sound, small kana, iteration marks (32+ characters)
    - Class 10-12: Currency symbols and abbreviations (19+ characters)
    - Class 13-16: Dashes, ellipsis, combining marks, and special characters
  - Customizable break iterator rules
  - Configuration-based rule generation (`KinsokuConfig`)
  - Platform support: macOS, Linux, Windows (desktop/server)
- `ICUBindings`: FFI bindings for ICU library
  - Support for custom break iterator rules
  - UTF-16 text processing
  - Multi-platform library loading

### Documentation
- Comprehensive README with examples
- `INTEGRATION_GUIDE.md`: Integration guide for tategaki package
- Complete API documentation
- Example code for both Pure Dart and ICU-based usage
- JIS X 4051:2004 compliance test suite

### Notes
- This is a **pure Dart package** with no Flutter dependencies
- Core functionality works on all platforms (Flutter, Web, CLI, Server)
- ICU features require native ICU library installation (desktop/server only)
- Extracted and enhanced from the tategaki package for broader reusability
