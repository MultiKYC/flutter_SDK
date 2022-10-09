import 'dart:io';

import 'package:injectable/injectable.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/data/api/base/api_http_overrides.dart';
import 'package:multi_kyc_sdk/src/domain/repository/general/configure_repository.dart';

@Singleton()
@internal
class ApiBaseRepositoryImpl {
  final ConfigureRepository _configureRepository;

  ApiBaseRepositoryImpl(this._configureRepository) {
    HttpOverrides.global = ApiHttpOverrides();
  }

  String getBaseUrl() {
    return _configureRepository.applicant.server;
  }
}
