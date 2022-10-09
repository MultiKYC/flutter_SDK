import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/retry.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/data/api/base/api_base_repository_impl.dart';
import 'package:multi_kyc_sdk/src/domain/exception/api_exception.dart';
import 'package:multi_kyc_sdk/src/domain/exception/not_found_exception.dart';
import 'package:multi_kyc_sdk/src/domain/repository/general/configure_repository.dart';
import 'package:multi_kyc_sdk/src/general/log_helper.dart';

@internal
abstract class BaseApiRepository with LogHelper {
  static const networkRequestsTimeout = 20; // 20 seconds
  static const tag = 'BaseApiRepository';

  static const defaultTimeout = Duration(seconds: networkRequestsTimeout);

  final ApiBaseRepositoryImpl _apiBaseRepository;
  final ConfigureRepository _configureRepository;

  late RetryClient _retryClient;

  BaseApiRepository(this._apiBaseRepository, this._configureRepository) {
    _retryClient = RetryClient(
      Client(),
      whenError: (e, stackTrace) {
        return e is SocketException || e is TimeoutException || e is http.ClientException || e is HandshakeException;
      },
    );
  }

  String get baseApiUrl {
    return _apiBaseRepository.getBaseUrl();
  }

  String getBasePath();

  String getApiUrl(String apiName) {
    return baseApiUrl + getBasePath() + apiName;
  }

  Future<ValidateState> validateResponse(http.Response response, {List<int>? passErrorCodes}) async {
    tLog.d('$tag:${runtimeType.toString()}', 'validateResponse, response code: ${response.statusCode}');

    if (passErrorCodes != null && passErrorCodes.contains(response.statusCode)) {
      return Future.value(ValidateState.fail);
    }

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return Future.value(ValidateState.success);
    } else if (response.statusCode == 400) {
      return Future.value(ValidateState.fail);
    } else if (response.statusCode == 404) {
      throw NotFoundException(
        applicantId: _configureRepository.applicant.applicantId,
        response: utf8.decode(response.bodyBytes),
        url: response.request.toString(),
      );
    } else {
      throw ApiException(
        applicantId: _configureRepository.applicant.applicantId,
        response: utf8.decode(response.bodyBytes),
        url: response.request.toString(),
        code: response.statusCode,
      );
    }
  }

  Future<Map<String, String>> prepareHeader({bool excludeAuthorizationHeader = false}) async {
    final Map<String, String> headers = <String, String>{};
    headers[HttpHeaders.contentTypeHeader] = 'application/json; charset=utf-8';
    tLog.d(tag, 'prepareHeader, headers: $headers');
    return Future.value(headers);
  }

  Future<http.Response> executeRequest({
    required RequestType requestType,
    required String url,
    Object? body,
    List<int>? passErrorCodes,
    bool excludeAuthorizationHeader = false,
  }) async {
    final uri = Uri.parse(Uri.encodeFull(url));
    http.Response response;
    final Map<String, String> headers = await prepareHeader(excludeAuthorizationHeader: excludeAuthorizationHeader);

    switch (requestType) {
      case RequestType.get:
        response = await _retryClient.get(uri, headers: headers).timeout(defaultTimeout);
        break;
      case RequestType.post:
        response = await _retryClient.post(uri, body: body, headers: headers).timeout(defaultTimeout);
        break;
      case RequestType.put:
        response = await _retryClient.put(uri, body: body, headers: headers).timeout(defaultTimeout);
        break;
      case RequestType.patch:
        response = await _retryClient.patch(uri, body: body, headers: headers).timeout(defaultTimeout);
        break;
      case RequestType.delete:
        response = await _retryClient.delete(uri, headers: headers).timeout(defaultTimeout);
        break;
    }

    return Future.value(response);
  }
}

enum ValidateState { success, fail, tokenUpdated }

enum RequestType { get, post, put, patch, delete }
