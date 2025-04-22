import 'package:infinite_shop/core/exception/base_error.dart';

/// Represents the different types of common errors that can occur.
enum CommonError implements BaseError {
  /// Represents an unknown error.
  /// This occurs when an error is thrown but the type is not recognized.
  unknown('unknown', 'An unknown error occurred. Please try again.'),

  /// Represents missing context error.
  missingContext(
    'missing_context',
    'Missing UI context. Please provide a valid context.',
  ),

  /// Represents parsing type error
  invalidType(
    'invalid_type',
    'An error occurred while parsing data. Please try again.',
  );

  /// Creates a new instance of [CommonError].
  const CommonError(this.code, this.message);

  /// The error code.
  @override
  final String code;

  /// The error message.
  @override
  final String message;
}
