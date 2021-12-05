class WebServiceException implements Exception {
  String message;

  WebServiceException({String message}) {
    message = message;
  }

  @override
  String toString() {
    return message;
  }
}

class UnauthorizedException extends WebServiceException {
  UnauthorizedException({String message}) : super(message: message);
}

// TODO: Implement more specific exception classes