import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart' as ml;
import 'package:injectable/injectable.dart';
import 'package:learning_input_image/learning_input_image.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/data/api/responses/api_entity_verification_media_type.dart';
import 'package:multi_kyc_sdk/src/domain/entity/api/api_response_status.dart';
import 'package:multi_kyc_sdk/src/domain/entity/kyc_step.dart';
import 'package:multi_kyc_sdk/src/domain/entity/liveness/selfie_type.dart';
import 'package:multi_kyc_sdk/src/domain/repository/api/api_verification_repository.dart';
import 'package:multi_kyc_sdk/src/domain/repository/helper/image_helper.dart';
import 'package:multi_kyc_sdk/src/domain/usecases/base/get_use_case.dart';
import 'package:multi_kyc_sdk/src/general/log_helper.dart';
import 'package:multi_kyc_sdk/src/presentation/injection/configure_dependencies.dart';

@LazySingleton()
@internal
class UploadSelfieData extends GetUseCase5<bool, String, KycStep, ml.InputImage, CameraImage, SelfieType> with LogHelper {
  static const tag = 'UploadSelfieData';

  final _apiVerificationRepository = getIt<ApiVerificationRepository>();
  final _imageHelper = getIt<ImageHelper>();

  UploadSelfieData();

  @override
  Future<bool> executeAsync(String secret, KycStep step, ml.InputImage image, CameraImage cameraImage, SelfieType selfieType) async {
    bool result = false;

    try {
      final ApiEntityVerificationMediaType? mediaType = _getApiEntityVerificationMediaType(selfieType);

      if (mediaType != null) {
        final checkResult = await _apiVerificationRepository.postMedia(
          secret,
          step.id,
          mediaType,
          (await _imageHelper.convertNv21ToJpg(cameraImage, image.inputImageData?.imageRotation ?? ml.InputImageRotation.rotation0deg))!,
        );

        if (checkResult.status == ApiResponseStatus.success) {
          result = true;
        }
      }

      tLog.d(tag, 'executeAsync, result: $result');
    } catch (e) {
      tLog.e(tag, e);
    }

    return Future.value(result);
  }

  ApiEntityVerificationMediaType? _getApiEntityVerificationMediaType(SelfieType type) {
    switch (type) {
      case SelfieType.none:
        return null;
      case SelfieType.center:
        return ApiEntityVerificationMediaType.selfie;
      case SelfieType.top:
        return ApiEntityVerificationMediaType.selfieTop;
      case SelfieType.bottom:
        return ApiEntityVerificationMediaType.selfieBottom;
      case SelfieType.left:
        return ApiEntityVerificationMediaType.selfieLeft;
      case SelfieType.right:
        return ApiEntityVerificationMediaType.selfieRight;
    }
  }
}
