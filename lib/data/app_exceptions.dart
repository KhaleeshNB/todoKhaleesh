class AppException implements Exception {
  final _message;
  final _prefix;
  AppException(this._message, this._prefix);

  @override
  String toString() {
    return "$_prefix $_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException(String message)
      : super(message, 'error during communication');
}

class BadRequestException extends AppException {
  BadRequestException(String message) : super(message, 'invalid request');
}

class UnauthorizedException extends AppException {
  UnauthorizedException(String message)
      : super(message, 'Unauthorized request');
}

class InvalidInputException extends AppException {
  InvalidInputException(String message) : super(message, 'Invalid input');
}
