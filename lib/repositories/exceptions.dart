class BaseException implements Exception {
  String? message;
  BaseException({this.message});
}

class ImageNotFoundException extends BaseException {
  ImageNotFoundException(String message) : super(message: message);
}

class ImageNotSelectedException extends BaseException {
  ImageNotSelectedException(String message) : super(message: message);
}