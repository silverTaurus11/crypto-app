import 'package:flutter/foundation.dart';

class AppLogger {
  static void i(String message) {
    if (kDebugMode) {
      print("ℹ️ INFO: $message");
    }
  }

  static void w(String message) {
    if (kDebugMode) {
      print("⚠️ WARNING: $message");
    }
  }

  static void e(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print("❌ ERROR: $message");
      if (error != null) print("   Exception: $error");
      if (stackTrace != null) print("   StackTrace: $stackTrace");
    }
  }

  static void d(String message) {
    if (kDebugMode) {
      print("🐛 DEBUG: $message");
    }
  }

  static void v(String message) {
    if (kDebugMode) {
      print("🔍 VERBOSE: $message");
    }
  }
}
