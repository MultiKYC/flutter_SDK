// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

@internal
class ApiException implements Exception {
  final String applicantId;
  final String url;
  final int code;
  final String response;

  ApiException({
    required this.applicantId,
    required this.url,
    required this.code,
    required this.response,
  });
}
