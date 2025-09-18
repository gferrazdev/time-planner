sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(String message, {dynamic errorCode}) = Failure<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get data => this is Success<T> ? (this as Success<T>).data : null;
  String? get message =>
      this is Failure<T> ? (this as Failure<T>).message : null;
  dynamic get errorCode =>
      this is Failure<T> ? (this as Failure<T>).errorCode : null;

  R when<R>({
    required R Function(T data) success,
    required R Function(String message, dynamic errorCode) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else {
      return failure(
          (this as Failure<T>).message, (this as Failure<T>).errorCode);
    }
  }
}

class Success<T> extends Result<T> {
  @override
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  @override
  final String message;
  @override
  final dynamic errorCode;
  const Failure(this.message, {this.errorCode});
}
