// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/data/api/base/api_base_repository_impl.dart';
import 'package:multi_kyc_sdk/src/data/api/base/base_api_repository.dart';
import 'package:multi_kyc_sdk/src/data/api/responses/api_entity_verification_document_country.dart';
import 'package:multi_kyc_sdk/src/data/api/responses/api_entity_verification_document_type.dart';
import 'package:multi_kyc_sdk/src/data/api/responses/api_entity_verification_media_type.dart';
import 'package:multi_kyc_sdk/src/data/api/responses/api_entity_verification_next_post.dart';
import 'package:multi_kyc_sdk/src/data/api/responses/api_entity_verification_status_get.dart';
import 'package:multi_kyc_sdk/src/domain/entity/api/api_response.dart';
import 'package:multi_kyc_sdk/src/domain/entity/api/api_response_status.dart';
import 'package:multi_kyc_sdk/src/domain/repository/api/api_verification_repository.dart';
import 'package:multi_kyc_sdk/src/domain/repository/general/configure_repository.dart';
import 'package:multi_kyc_sdk/src/general/log_helper.dart';

@LazySingleton(as: ApiVerificationRepository)
@internal
class ApiVerificationRepositoryImpl extends BaseApiRepository with LogHelper implements ApiVerificationRepository {
  static const tag = 'ApiVerificationRepositoryImpl';

  final utf8Encoder = const Utf8Encoder();

  late ConfigureRepository _configureRepository;

  ApiVerificationRepositoryImpl(
    ApiBaseRepositoryImpl apiBaseRepository,
    ConfigureRepository configureRepository,
  ) : super(apiBaseRepository, configureRepository) {
    _configureRepository = configureRepository;
  }

  @override
  String getBasePath() {
    return '/api/ui/v1/';
  }

  @override
  Future<ApiResponse<ApiEntityVerificationStatusGet>> getStatus() async {
    ApiResponseStatus status = ApiResponseStatus.error;
    ApiEntityVerificationStatusGet? result;

    final String url = getApiUrl('verification/${_configureRepository.applicant.applicantId}/');
    tLog.d(tag, 'getStatus, url: $url');
    final response = await executeRequest(requestType: RequestType.get, url: url);

    if (await validateResponse(response) == ValidateState.success) {
      final decodedBody = utf8.decode(response.bodyBytes);
      result = ApiEntityVerificationStatusGet.fromJson(json.decode(decodedBody) as Map<String, dynamic>);
      status = ApiResponseStatus.success;
    }

    return Future.value(ApiResponse<ApiEntityVerificationStatusGet>(data: result, status: status));
  }

  @override
  Future<ApiResponse<ApiEntityVerificationNextPost>> postNext(int stepId) async {
    ApiResponseStatus status = ApiResponseStatus.error;
    ApiEntityVerificationNextPost? result;

    final String url = getApiUrl('verification/${_configureRepository.applicant.applicantId}/steps/$stepId/next/');
    tLog.d(tag, 'postNext, url: $url');
    final response = await executeRequest(requestType: RequestType.post, url: url);

    if (await validateResponse(response) == ValidateState.success) {
      final decodedBody = utf8.decode(response.bodyBytes);
      result = ApiEntityVerificationNextPost.fromJson(json.decode(decodedBody) as Map<String, dynamic>);
      status = ApiResponseStatus.success;
    }

    return Future.value(ApiResponse<ApiEntityVerificationNextPost>(data: result, status: status));
  }

  @override
  Future<ApiResponse<Object>> postMedia(String secret, int stepId, ApiEntityVerificationMediaType mediaType, Uint8List imageBytes) async {
    ApiResponseStatus status = ApiResponseStatus.error;
    Object? result;

    final String url = getApiUrl('verification/${_configureRepository.applicant.applicantId}/steps/$stepId/medias/');
    tLog.d(tag, 'postMedia, url: $url');

    final String mediaTypeValue;

    switch (mediaType) {
      case ApiEntityVerificationMediaType.selfie:
        mediaTypeValue = 'selfie';
        break;
      case ApiEntityVerificationMediaType.selfieLeft:
        mediaTypeValue = 'selfie_left';
        break;
      case ApiEntityVerificationMediaType.selfieRight:
        mediaTypeValue = 'selfie_right';
        break;
      case ApiEntityVerificationMediaType.selfieTop:
        mediaTypeValue = 'selfie_top';
        break;
      case ApiEntityVerificationMediaType.selfieBottom:
        mediaTypeValue = 'selfie_bottom';
        break;
    }

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';

    final Map<String, String> headers = <String, String>{};
    headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data';

    final request = http.MultipartRequest("POST", Uri.parse(url));
    request.headers.addAll(headers);
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        contentType: MediaType('image', 'jpg'),
        filename: fileName,
      ),
    );
    request.fields['type'] = mediaTypeValue;
    request.fields['sign'] = _calculateHash(
      type: mediaTypeValue,
      secret: secret,
      applicantId: _configureRepository.applicant.applicantId,
      imageBytesLength: imageBytes.length,
    );

    await request.send().then((response) async {
      final responseMessage = await response.stream.bytesToString();
      tLog.d(tag, responseMessage);

      if (response.statusCode == 200) {
        status = ApiResponseStatus.success;
      }
    });

    return Future.value(ApiResponse<Object>(data: result, status: status));
  }

  @override
  Future<ApiResponse<List<ApiEntityVerificationDocumentCountry>>> getDocumentsCountries(int stepId) async {
    ApiResponseStatus status = ApiResponseStatus.error;
    final List<ApiEntityVerificationDocumentCountry> result = [];

    final String url = getApiUrl('verification/${_configureRepository.applicant.applicantId}/steps/$stepId/documents/countries/');
    tLog.d(tag, 'getDocumentsCountries, url: $url');
    final response = await executeRequest(requestType: RequestType.get, url: url);

    if (await validateResponse(response) == ValidateState.success) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final List responseOjb = json.decode(decodedBody) as List;

      for (final item in responseOjb) {
        result.add(ApiEntityVerificationDocumentCountry.fromJson(item as Map<String, dynamic>));
      }

      status = ApiResponseStatus.success;
    }

    return Future.value(ApiResponse<List<ApiEntityVerificationDocumentCountry>>(data: result, status: status));
  }

  @override
  Future<ApiResponse<List<ApiEntityVerificationDocumentType>>> getDocumentsTypes(int stepId, int countryId) async {
    ApiResponseStatus status = ApiResponseStatus.error;
    final List<ApiEntityVerificationDocumentType> result = [];

    final String url =
        getApiUrl('verification/${_configureRepository.applicant.applicantId}/steps/$stepId/documents/types/?country_id=$countryId');
    tLog.d(tag, 'getDocumentsTypes, url: $url');
    final response = await executeRequest(requestType: RequestType.get, url: url);

    if (await validateResponse(response) == ValidateState.success) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final List responseOjb = json.decode(decodedBody) as List;

      for (final item in responseOjb) {
        result.add(ApiEntityVerificationDocumentType.fromJson(item as Map<String, dynamic>));
      }

      status = ApiResponseStatus.success;
    }

    return Future.value(ApiResponse<List<ApiEntityVerificationDocumentType>>(data: result, status: status));
  }

  @override
  Future<ApiResponse<StreamedResponse>> postDocument(String secret, int stepId, String page, Uint8List imageBytes) async {
    ApiResponseStatus status = ApiResponseStatus.error;
    StreamedResponse? result;

    final String url = getApiUrl('verification/${_configureRepository.applicant.applicantId}/steps/$stepId/documents/');
    tLog.d(tag, 'postDocument, url: $url');

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    final Map<String, String> headers = <String, String>{};
    headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data';

    final request = http.MultipartRequest("POST", Uri.parse(url));
    request.headers.addAll(headers);
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        contentType: MediaType('image', 'jpg'),
        filename: fileName,
      ),
    );
    request.fields['page'] = page;
    request.fields['sign'] = _calculateHash(
      type: page,
      secret: secret,
      applicantId: _configureRepository.applicant.applicantId,
      imageBytesLength: imageBytes.length,
    );

    await request.send().then((response) async {
      result = response;

      if (response.statusCode == 200) {
        status = ApiResponseStatus.success;
      }
    });

    return Future.value(ApiResponse<StreamedResponse>(data: result, status: status));
  }

  String _calculateHash({
    required String applicantId,
    required String type,
    required String secret,
    required int imageBytesLength,
  }) {
    return _generateMd5ForString('$applicantId$type$secret$imageBytesLength');
  }

  String _generateMd5ForString(String data) {
    final content = utf8Encoder.convert(data);
    final digest = crypto.md5.convert(content);
    return hex.encode(digest.bytes);
  }
}
