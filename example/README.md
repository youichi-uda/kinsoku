# kinsoku Examples

This directory contains example code demonstrating the usage of the kinsoku package.

## Examples

### `icu_example.dart`

Comprehensive examples of ICU-based kinsoku processing with JIS X 4051:2004 compliance.

**Prerequisites:**
- ICU library must be installed on your system
- macOS: `brew install icu4c`
- Linux: `sudo apt install libicu-dev`
- Windows: Download ICU binaries from https://github.com/unicode-org/icu/releases

**Run:**
```bash
dart run icu_example.dart
```

**Includes:**
1. Default UAX #14 rules
2. JIS X 4051:2004 complete compliance
3. Custom break iterator rules
4. Configuration-based rules
5. Finding all break positions
6. Comparing different rule sets

## Pure Dart Usage

For Pure Dart usage without ICU dependency, see the main README.md examples.

## More Information

- Main README: ../README.md
- Integration Guide: ../INTEGRATION_GUIDE.md
- API Documentation: https://pub.dev/documentation/kinsoku/
