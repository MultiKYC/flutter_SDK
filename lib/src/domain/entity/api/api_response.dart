// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/domain/entity/api/api_response_status.dart';

@internal
class ApiResponse<T> {
  ApiResponseStatus status;

  final T? data;

  ApiResponse({required this.status, this.data});

  factory ApiResponse.emptyStatus(ApiResponseStatus status) {
    return ApiResponse(status: status);
  }

  factory ApiResponse.emptyError() {
    return ApiResponse(status: ApiResponseStatus.error);
  }
}

@internal
class ApiResponse2<T1, T2> {
  final T1? data1;

  final T2? data2;

  ApiResponseStatus status;

  ApiResponse2({required this.status, this.data1, this.data2});

  factory ApiResponse2.emptyStatus(ApiResponseStatus status) {
    return ApiResponse2(status: status);
  }

  factory ApiResponse2.emptyError() {
    return ApiResponse2(status: ApiResponseStatus.error);
  }
}

@internal
class ApiResponseErrorData<T, E> extends ApiResponse<T> {
  final E? errorData;

  ApiResponseErrorData({required super.status, super.data, this.errorData});

  factory ApiResponseErrorData.error(E? data) {
    return ApiResponseErrorData(status: ApiResponseStatus.error, errorData: data);
  }
}
