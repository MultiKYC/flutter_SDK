// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

@internal
enum ApiResponseErrorCode {
  none,
  error_400,
  error_401,
  error_402,
  error_403,
  error_404,
  error_405,
  error_409,
}

@internal
extension ApiResponseErrorCodeExtension on int {
  ApiResponseErrorCode toResponseErrorCode() {
    switch (this) {
      case 400:
        return ApiResponseErrorCode.error_400;
      case 401:
        return ApiResponseErrorCode.error_401;
      case 402:
        return ApiResponseErrorCode.error_402;
      case 403:
        return ApiResponseErrorCode.error_403;
      case 404:
        return ApiResponseErrorCode.error_404;
      case 405:
        return ApiResponseErrorCode.error_405;
      case 409:
        return ApiResponseErrorCode.error_409;
      default:
        return ApiResponseErrorCode.none;
    }
  }
}
