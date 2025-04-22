import 'package:infinite_shop/core/logger/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:talker/talker.dart';

/// A logger implementation that logs messages using the `logger` package and
/// sends them to Sentry (if enabled).
class Logger implements AppLogger {
  final _logger = Talker()
    ..configure(
      logger: TalkerLogger(
        // ignore: avoid_redundant_argument_values
        settings: TalkerLoggerSettings(
          // ignore: avoid_redundant_argument_values
          level: kDebugMode ? LogLevel.verbose : LogLevel.error,
        ),
      ),
    );

  /// Logs a debug message with an optional flag to send it to Sentry.
  @override
  void debug(String message, {bool sendToCrashlytics = false}) {
    _logger.debug(message);
    if (sendToCrashlytics) {}
  }

  /// Logs an error message with an optional error and stack trace, and an
  /// optional flag to send it to Sentry.
  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    bool sendToCrashlytics = false,
  }) {
    _logger.error(message, error, stackTrace);
    if (sendToCrashlytics) {}
  }

  /// Logs an info message with an optional flag to send it to Sentry.
  @override
  void info(String message, {bool sendToCrashlytics = false}) {
    _logger.info(message);
    if (sendToCrashlytics) {}
  }

  /// Logs a warning message with an optional flag to send it to Sentry.
  @override
  void warning(String message, {bool sendToCrashlytics = false}) {
    _logger.warning(message);
    if (sendToCrashlytics) {}
  }
}
