/// ICU-based Japanese text processing with customizable line breaking rules
///
/// This library provides ICU (International Components for Unicode) based
/// kinsoku processing with full UAX #14 support and customizable rules.
///
/// **Requirements:**
/// - ICU library must be installed on your system
/// - Windows: Download ICU binaries and add to PATH
/// - macOS: `brew install icu4c`
/// - Linux: `apt install libicu-dev`
///
/// ## Example Usage:
///
/// ### Default UAX #14 Rules
/// ```dart
/// import 'package:kinsoku/icu.dart';
///
/// final processor = ICUKinsokuProcessor();
/// final canBreak = processor.canBreakAt('これは禁則処理です。', 10);
/// print('Can break at position 10: $canBreak');
/// ```
///
/// ### Complete JIS X 4051:2004 Compliance
/// ```dart
/// final processor = ICUKinsokuProcessor.withJISX4051Rules();
/// final breakPos = processor.findBreakPosition('長いテキスト...', 20);
/// // Includes ALL JIS X 4051 character classes and rules
/// ```
///
/// ### Custom Rules
/// ```dart
/// // Define custom break iterator rules in ICU syntax
/// final customRules = '''
/// \$CL_OP = [\\u0028 \\u300C];  # Opening brackets
/// \$CL_CL = [\\u0029 \\u300D];  # Closing brackets
/// × \$CL_OP;  # No break after opening
/// \$CL_CL ×;  # No break before closing
/// ÷;  # Default: allow break
/// ''';
///
/// final processor = ICUKinsokuProcessor.withCustomRules(customRules);
/// ```
///
/// ### Configuration-based Rules
/// ```dart
/// final config = KinsokuConfig(
///   gyotoKinsoku: {'。', '、', '）'},
///   gyomatsuKinsoku: {'（'},
///   burasageAllowed: {'。', '、'},
/// );
///
/// final rules = config.toICURules();
/// final processor = ICUKinsokuProcessor.withCustomRules(rules);
/// ```
///
/// ## ICU Rule Syntax
///
/// ICU break iterator rules use a specialized syntax:
/// - `$VAR = [chars];` - Define character class
/// - `×` - No break (禁則)
/// - `÷` - Allow break
/// - `A × B` - No break between A and B
/// - `× A` - No break before A
/// - `A ×` - No break after A
///
/// See: https://unicode-org.github.io/icu/userguide/boundaryanalysis/break-rules.html
///
/// ## Differences from Pure Dart Implementation
///
/// | Feature | Pure Dart | ICU-based |
/// |---------|-----------|-----------|
/// | Dependencies | None | ICU library required |
/// | Unicode support | Basic | Full UAX #14 |
/// | Customization | Limited | Extensive |
/// | Performance | Fast | Fast (native) |
/// | Platform | All | Desktop/Server |
///
library kinsoku_icu;

export 'src/icu/icu_bindings.dart';
export 'src/icu/icu_kinsoku_processor.dart';
export 'src/icu/jis_x_4051_classes.dart';
