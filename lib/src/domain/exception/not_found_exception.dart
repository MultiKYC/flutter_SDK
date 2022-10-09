// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/domain/exception/api_exception.dart';

@internal
class NotFoundException extends ApiException {
  NotFoundException({
    required super.applicantId,
    required super.url,
    required super.response,
  }) : super(code: 404);
}
