import 'package:injectable/injectable.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/domain/entity/api/api_response_status.dart';
import 'package:multi_kyc_sdk/src/domain/entity/kyc_step.dart';
import 'package:multi_kyc_sdk/src/domain/repository/api/api_verification_repository.dart';
import 'package:multi_kyc_sdk/src/domain/usecases/base/get_use_case.dart';
import 'package:multi_kyc_sdk/src/general/log_helper.dart';
import 'package:multi_kyc_sdk/src/presentation/injection/configure_dependencies.dart';

@LazySingleton()
@internal
class CheckSelfieData extends GetUseCase2<bool, String, KycStep> with LogHelper {
  static const tag = 'CheckSelfieData';

  final _apiVerificationRepository = getIt<ApiVerificationRepository>();

  CheckSelfieData();

  @override
  Future<bool> executeAsync(String secret, KycStep step) async {
    bool result = false;

    try {
      final postNextResponse = await _apiVerificationRepository.postNext(step.id);

      if (postNextResponse.status == ApiResponseStatus.success) {
        result = true;
      }

      tLog.d(tag, 'executeAsync, result: $result');
    } catch (e) {
      tLog.e(tag, e);
    }

    return Future.value(result);
  }
}
