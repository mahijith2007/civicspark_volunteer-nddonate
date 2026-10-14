import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class FirebaseConfig {
  static bool _isInitialized = false;
  static String? _initializationError;
  static bool _useMockAuth = false;

  static bool get isInitialized => _isInitialized;
  static String? get initializationError => _initializationError;
  static bool get isMockMode => _useMockAuth || !_isInitialized;

  /// Attempts to initialize Firebase using generated DefaultFirebaseOptions.
  /// If the platform is not yet supported (or in unit tests), it safely falls back
  /// to Local Demo mode without crashing the app.
  static Future<void> initialize() async {
    try {
      FirebaseOptions? options;
      try {
        options = DefaultFirebaseOptions.currentPlatform;
      } catch (_) {
        // Platform not configured in options (e.g. windows desktop or unit test)
      }

      if (options != null) {
        await Firebase.initializeApp(options: options);
      } else {
        await Firebase.initializeApp();
      }
      _isInitialized = true;
      _initializationError = null;
      debugPrint('[FirebaseConfig] Firebase successfully initialized with project options.');
    } catch (e) {
      _isInitialized = false;
      _initializationError = e.toString();
      _useMockAuth = true;
      debugPrint('[FirebaseConfig] Firebase initialization note: $e');
      debugPrint('[FirebaseConfig] CivicSpark is running with Local Demo Bridge active.');
    }
  }

  /// Manually force mock or live mode for testing
  static void setMockMode(bool enabled) {
    _useMockAuth = enabled;
  }
}
