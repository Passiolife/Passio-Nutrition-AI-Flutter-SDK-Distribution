/// A sealed class representing the result of an operation, which can either be a success or an error.
sealed class PassioResult<T> {
  /// Constructor for the `PassioResult` class.
  const PassioResult();
}

/// A final class representing an error result of an operation.
///
/// The `Error` class extends `PassioResult<Never>` and contains an error message.
final class Error extends PassioResult<Never> {
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

/// A class representing a void type.
///
/// This class is used when a method or operation does not return a value.
class VoidType {
  /// Constructor for the `VoidType` class.
  const VoidType();
}
