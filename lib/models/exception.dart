class WebServiceException implements Exception {
  String message;

  WebServiceException({String message}) {
    this.message = message;
  }
}

class UnauthorizedException extends WebServiceException {
  UnauthorizedException({String message}) : super(message: message);
}

// TODO: Implement more specific exception classes