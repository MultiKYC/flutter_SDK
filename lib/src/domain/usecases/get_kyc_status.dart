import 'package:injectable/injectable.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/domain/entity/api/api_response_status.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_country.dart';
import 'package:multi_kyc_sdk/src/domain/entity/kyc_status.dart';
import 'package:multi_kyc_sdk/src/domain/entity/kyc_step_type.dart';
import 'package:multi_kyc_sdk/src/domain/entity/mapper/documents/document_country_mapper.dart';
import 'package:multi_kyc_sdk/src/domain/entity/mapper/documents/document_document_type_mapper.dart';
import 'package:multi_kyc_sdk/src/domain/entity/mapper/kyc_status_mapper.dart';
import 'package:multi_kyc_sdk/src/domain/repository/api/api_verification_repository.dart';
import 'package:multi_kyc_sdk/src/domain/usecases/base/get_use_case.dart';
import 'package:multi_kyc_sdk/src/general/log_helper.dart';
import 'package:multi_kyc_sdk/src/presentation/injection/configure_dependencies.dart';

@LazySingleton()
@internal
class GetKycStatus extends GetUseCase<KycStatus> with LogHelper {
  static const tag = 'DetectSelfieData';

  final _apiVerificationRepository = getIt<ApiVerificationRepository>();
  final _kycStatusMapper = getIt<KycStatusMapper>();
  final _documentCountryMapper = getIt<DocumentCountryMapper>();
  final _documentDocumentTypeMapper = getIt<DocumentDocumentTypeMapper>();

  @override
  Future<KycStatus> executeAsync() async {
    final apiResult = await _apiVerificationRepository.getStatus();

    final KycStatus kycStatus = _kycStatusMapper.map(apiResult.data!);

    List<DocumentCountry> stepData = [];

    if (kycStatus.step != null && kycStatus.step!.stepType == KycStepType.document) {
      final countries = await _apiVerificationRepository.getDocumentsCountries(kycStatus.step!.id);

      if (countries.status == ApiResponseStatus.success && countries.data != null && countries.data!.isNotEmpty) {
        stepData = _documentCountryMapper.mapList(countries.data!);

        for (final item in stepData) {
          final documentsApi = await _apiVerificationRepository.getDocumentsTypes(kycStatus.step!.id, item.id);

          if (documentsApi.status == ApiResponseStatus.success && documentsApi.data != null && documentsApi.data!.isNotEmpty) {
            final documents = _documentDocumentTypeMapper.mapList(documentsApi.data!);
            item.documents.addAll(documents);
          }
        }
      }
    }

    return Future.value(_kycStatusMapper.map(apiResult.data!).cloneWithStepData(stepData));
  }
}
