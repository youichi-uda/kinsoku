// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';

/// ICU Break Iterator Type
enum UBreakIteratorType {
  character(0),
  word(1),
  line(2),
  sentence(3),
  title(4);

  final int value;
  const UBreakIteratorType(this.value);
}

/// ICU Error Code
typedef UErrorCode = ffi.Int32;

/// ICU Break Iterator (opaque pointer)
typedef UBreakIterator = ffi.Pointer<ffi.Void>;

/// ICU Text (UChar* - UTF-16)
typedef UChar = ffi.Uint16;

/// Helper function to convert Dart string to native UTF-8 Char pointer
/// Uses calloc for proper memory management
ffi.Pointer<ffi.Char> _stringToNativeChar(String str) {
  final units = utf8.encode(str);
  final result = calloc<ffi.Char>(units.length + 1);
  final nativeString = result.cast<ffi.Uint8>();
  for (int i = 0; i < units.length; i++) {
    nativeString[i] = units[i];
  }
  nativeString[units.length] = 0; // Null terminator
  return result;
}

/// ICU Bindings for Break Iterator
///
/// This class provides FFI bindings to ICU's break iterator functionality,
/// allowing for Unicode-compliant line breaking with customizable rules.
class ICUBindings {
  late final ffi.DynamicLibrary _lib;

  // Function signatures
  late final _ubrk_open = _lib.lookupFunction<
      ffi.Pointer<ffi.Void> Function(
        ffi.Int32 type,
        ffi.Pointer<ffi.Char> locale,
        ffi.Pointer<UChar> text,
        ffi.Int32 textLength,
        ffi.Pointer<UErrorCode> status,
      ),
      UBreakIterator Function(
        int type,
        ffi.Pointer<ffi.Char> locale,
        ffi.Pointer<UChar> text,
        int textLength,
        ffi.Pointer<UErrorCode> status,
      )>('ubrk_open');

  late final _ubrk_openRules = _lib.lookupFunction<
      ffi.Pointer<ffi.Void> Function(
        ffi.Pointer<UChar> rules,
        ffi.Int32 rulesLength,
        ffi.Pointer<UChar> text,
        ffi.Int32 textLength,
        ffi.Pointer<ffi.Int32> parseError,
        ffi.Pointer<UErrorCode> status,
      ),
      UBreakIterator Function(
        ffi.Pointer<UChar> rules,
        int rulesLength,
        ffi.Pointer<UChar> text,
        int textLength,
        ffi.Pointer<ffi.Int32> parseError,
        ffi.Pointer<UErrorCode> status,
      )>('ubrk_openRules');

  late final _ubrk_setText = _lib.lookupFunction<
      ffi.Void Function(
        ffi.Pointer<ffi.Void> bi,
        ffi.Pointer<UChar> text,
        ffi.Int32 textLength,
        ffi.Pointer<UErrorCode> status,
      ),
      void Function(
        UBreakIterator bi,
        ffi.Pointer<UChar> text,
        int textLength,
        ffi.Pointer<UErrorCode> status,
      )>('ubrk_setText');

  late final _ubrk_following = _lib.lookupFunction<
      ffi.Int32 Function(
        ffi.Pointer<ffi.Void> bi,
        ffi.Int32 offset,
      ),
      int Function(
        UBreakIterator bi,
        int offset,
      )>('ubrk_following');

  late final _ubrk_preceding = _lib.lookupFunction<
      ffi.Int32 Function(
        ffi.Pointer<ffi.Void> bi,
        ffi.Int32 offset,
      ),
      int Function(
        UBreakIterator bi,
        int offset,
      )>('ubrk_preceding');

  late final _ubrk_isBoundary = _lib.lookupFunction<
      ffi.Bool Function(
        ffi.Pointer<ffi.Void> bi,
        ffi.Int32 offset,
      ),
      bool Function(
        UBreakIterator bi,
        int offset,
      )>('ubrk_isBoundary');

  late final _ubrk_getRuleStatus = _lib.lookupFunction<
      ffi.Int32 Function(
        ffi.Pointer<ffi.Void> bi,
      ),
      int Function(
        UBreakIterator bi,
      )>('ubrk_getRuleStatus');

  late final _ubrk_close = _lib.lookupFunction<
      ffi.Void Function(
        ffi.Pointer<ffi.Void> bi,
      ),
      void Function(
        UBreakIterator bi,
      )>('ubrk_close');

  /// Initialize ICU bindings
  ///
  /// Attempts to load the ICU library from platform-specific locations.
  /// Throws an exception if the library cannot be found.
  ICUBindings() {
    _lib = _loadICULibrary();
  }

  /// Load ICU library based on platform
  ffi.DynamicLibrary _loadICULibrary() {
    Object? lastError;

    if (Platform.isWindows) {
      // Windows: Try common ICU library names
      for (final name in ['icuuc74.dll', 'icuuc73.dll', 'icuuc.dll']) {
        try {
          return ffi.DynamicLibrary.open(name);
        } catch (e) {
          lastError = e;
          continue;
        }
      }
      throw UnsupportedError(
        'ICU library not found on Windows. Please install ICU and ensure '
        'icuuc.dll is in your PATH or system directory. Last error: $lastError',
      );
    } else if (Platform.isMacOS) {
      // macOS: System ICU or Homebrew
      for (final path in [
        '/usr/lib/libicucore.dylib', // System ICU
        '/opt/homebrew/opt/icu4c/lib/libicuuc.dylib', // Homebrew (Apple Silicon)
        '/usr/local/opt/icu4c/lib/libicuuc.dylib', // Homebrew (Intel)
      ]) {
        try {
          return ffi.DynamicLibrary.open(path);
        } catch (e) {
          lastError = e;
          continue;
        }
      }
      throw UnsupportedError(
        'ICU library not found on macOS. Install via: brew install icu4c. Last error: $lastError',
      );
    } else if (Platform.isLinux) {
      // Linux: System ICU
      for (final name in ['libicuuc.so', 'libicuuc.so.74', 'libicuuc.so.73']) {
        try {
          return ffi.DynamicLibrary.open(name);
        } catch (e) {
          lastError = e;
          continue;
        }
      }
      throw UnsupportedError(
        'ICU library not found on Linux. Install via: apt install libicu-dev. Last error: $lastError',
      );
    } else {
      throw UnsupportedError('Platform not supported: ${Platform.operatingSystem}');
    }
  }

  /// Open a break iterator with default rules
  UBreakIterator open(
    UBreakIteratorType type,
    String locale,
    String? text,
  ) {
    final status = calloc<UErrorCode>();
    status.value = 0;

    ffi.Pointer<ffi.Char> localePtr = ffi.nullptr;
    ffi.Pointer<UChar> textPtr = ffi.nullptr;

    try {
      localePtr = _stringToNativeChar(locale);
      int textLength = 0;

      if (text != null) {
        final utf16 = text.codeUnits;
        textPtr = calloc<UChar>(utf16.length);
        for (int i = 0; i < utf16.length; i++) {
          textPtr[i] = utf16[i];
        }
        textLength = utf16.length;
      }

      final iterator = _ubrk_open(
        type.value,
        localePtr,
        textPtr,
        textLength,
        status,
      );

      if (status.value != 0) {
        throw Exception('ICU error: ${status.value}');
      }

      return iterator;
    } finally {
      if (localePtr != ffi.nullptr) {
        calloc.free(localePtr);
      }
      if (textPtr != ffi.nullptr) {
        calloc.free(textPtr);
      }
      calloc.free(status);
    }
  }

  /// Open a break iterator with custom rules
  ///
  /// [rules] Custom break iterator rules in ICU format
  /// [text] Initial text (optional)
  UBreakIterator openRules(
    String rules,
    String? text,
  ) {
    final status = calloc<UErrorCode>();
    final parseError = calloc<ffi.Int32>();
    status.value = 0;

    ffi.Pointer<UChar> rulesPtr = ffi.nullptr;
    ffi.Pointer<UChar> textPtr = ffi.nullptr;

    try {
      // Convert rules to UTF-16
      final rulesUtf16 = rules.codeUnits;
      rulesPtr = calloc<UChar>(rulesUtf16.length);
      for (int i = 0; i < rulesUtf16.length; i++) {
        rulesPtr[i] = rulesUtf16[i];
      }

      // Convert text to UTF-16
      int textLength = 0;
      if (text != null) {
        final textUtf16 = text.codeUnits;
        textPtr = calloc<UChar>(textUtf16.length);
        for (int i = 0; i < textUtf16.length; i++) {
          textPtr[i] = textUtf16[i];
        }
        textLength = textUtf16.length;
      }

      final iterator = _ubrk_openRules(
        rulesPtr,
        rulesUtf16.length,
        textPtr,
        textLength,
        parseError,
        status,
      );

      if (status.value != 0) {
        throw Exception('ICU error: ${status.value}, parse error at: ${parseError.value}');
      }

      return iterator;
    } finally {
      if (rulesPtr != ffi.nullptr) {
        calloc.free(rulesPtr);
      }
      if (textPtr != ffi.nullptr) {
        calloc.free(textPtr);
      }
      calloc.free(parseError);
      calloc.free(status);
    }
  }

  /// Set text for an existing break iterator
  void setText(UBreakIterator iterator, String text) {
    final status = calloc<UErrorCode>();
    status.value = 0;

    ffi.Pointer<UChar> textPtr = ffi.nullptr;

    try {
      final utf16 = text.codeUnits;
      textPtr = calloc<UChar>(utf16.length);
      for (int i = 0; i < utf16.length; i++) {
        textPtr[i] = utf16[i];
      }

      _ubrk_setText(iterator, textPtr, utf16.length, status);

      if (status.value != 0) {
        throw Exception('ICU error: ${status.value}');
      }
    } finally {
      if (textPtr != ffi.nullptr) {
        calloc.free(textPtr);
      }
      calloc.free(status);
    }
  }

  /// Find next break position after offset
  int following(UBreakIterator iterator, int offset) {
    return _ubrk_following(iterator, offset);
  }

  /// Find previous break position before offset
  int preceding(UBreakIterator iterator, int offset) {
    return _ubrk_preceding(iterator, offset);
  }

  /// Check if position is a break boundary
  bool isBoundary(UBreakIterator iterator, int offset) {
    return _ubrk_isBoundary(iterator, offset);
  }

  /// Get rule status for current position
  int getRuleStatus(UBreakIterator iterator) {
    return _ubrk_getRuleStatus(iterator);
  }

  /// Close and free a break iterator
  void close(UBreakIterator iterator) {
    _ubrk_close(iterator);
  }
}
