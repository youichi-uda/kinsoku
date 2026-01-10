# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
