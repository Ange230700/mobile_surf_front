// lib/config.dart

/// At compile time, Dart will substitute in the value of --dart-define=API_BASE_URL=...
/// If you forget to pass it, this defaultValue will be used instead.
const String apiBase = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://mobile-surf-back.onrender.com',
);
