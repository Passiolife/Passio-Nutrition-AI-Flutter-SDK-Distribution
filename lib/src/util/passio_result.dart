/// A sealed class representing the result of an operation, which can either be a success or an error.
///
/// Evaluate the result using a switch statement:
/// ```dart
/// switch (result) {
///   case Success(): {
///     print(result.value);
///   }
///   case Error(): {
///     print(result.error);
///   }
/// }
/// ```
sealed class PassioResult<T> {
  /// Constructor for the `PassioResult` class.
  const PassioResult();
}

/// A final class representing an error result of an operation.
///
/// The `Error` class extends `PassioResult<Never>` and contains an error message.
final class Error<T> extends PassioResult<T> {
  /// The error message describing the reason for the error.
  final String message;

  /// Constructor for creating an `Error` instance.
  ///
  /// Takes a [message] parameter which provides the error details.
  const Error(this.message);
}

/// A final class representing a successful result of an operation.
///
/// The `Success` class extends `PassioResult<T>` and contains the result value.
final class Success<T> extends PassioResult<T> {
  /// The value of the successful result.
  final T value;

  /// Constructor for creating a `Success` instance.
  ///
  /// Takes a [value] parameter which provides the successful result.
  const Success(this.value);
}
