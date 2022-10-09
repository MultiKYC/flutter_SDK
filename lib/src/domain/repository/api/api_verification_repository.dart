import 'dart:typed_data';

import 'package:http/http.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/data/api/responses/api_entity_verification_document_country.dart';
import 'package:multi_kyc_sdk/src/data/api/responses/api_entity_verification_document_type.dart';
import 'package:multi_kyc_sdk/src/data/api/responses/api_entity_verification_media_type.dart';
import 'package:multi_kyc_sdk/src/data/api/responses/api_entity_verification_next_post.dart';
import 'package:multi_kyc_sdk/src/data/api/responses/api_entity_verification_status_get.dart';
import 'package:multi_kyc_sdk/src/domain/entity/api/api_response.dart';

@internal
abstract class ApiVerificationRepository {
  Future<ApiResponse<ApiEntityVerificationStatusGet>> getStatus();

  Future<ApiResponse<ApiEntityVerificationNextPost>> postNext(int stepId);

  Future<ApiResponse<Object>> postMedia(String secret, int stepId, ApiEntityVerificationMediaType mediaType, Uint8List imageBytes);

  Future<ApiResponse<List<ApiEntityVerificationDocumentCountry>>> getDocumentsCountries(int stepId);

  Future<ApiResponse<List<ApiEntityVerificationDocumentType>>> getDocumentsTypes(int stepId, int countryId);

  Future<ApiResponse<StreamedResponse>> postDocument(String secret, int stepId, String page, Uint8List imageBytes);
}
