import 'dart:convert';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart' as ml;
import 'package:injectable/injectable.dart';
import 'package:learning_input_image/learning_input_image.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/domain/entity/api/api_response_status.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_detect_error.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_detect_error_type.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_document_page.dart';
import 'package:multi_kyc_sdk/src/domain/entity/kyc_step.dart';
import 'package:multi_kyc_sdk/src/domain/repository/api/api_verification_repository.dart';
import 'package:multi_kyc_sdk/src/domain/repository/helper/image_helper.dart';
import 'package:multi_kyc_sdk/src/domain/usecases/base/get_use_case.dart';
import 'package:multi_kyc_sdk/src/general/log_helper.dart';
import 'package:multi_kyc_sdk/src/presentation/injection/configure_dependencies.dart';

@LazySingleton()
@internal
class UploadDocumentFromCamera extends GetUseCase5<DocumentDetectError, String, KycStep, ml.InputImage, CameraImage, DocumentDocumentPage>
    with LogHelper {
  static const tag = 'UploadDocumentFromCamera';

  final _apiVerificationRepository = getIt<ApiVerificationRepository>();
  final _imageHelper = getIt<ImageHelper>();

  @override
  Future<DocumentDetectError> executeAsync(
    String secret,
    KycStep step,
    ml.InputImage image,
    CameraImage cameraImage,
    DocumentDocumentPage page,
  ) async {
    DocumentDetectErrorType result = DocumentDetectErrorType.errorGeneral;

    try {
      final String pageValue = page.code;
      final checkResult = await _apiVerificationRepository.postDocument(
        secret,
        step.id,
        pageValue,
        (await _imageHelper.convertNv21ToJpg(cameraImage, image.inputImageData?.imageRotation ?? ml.InputImageRotation.rotation0deg))!,
      );

      if (checkResult.status == ApiResponseStatus.success) {
        result = DocumentDetectErrorType.none;
      } else {
        if (checkResult.data!.statusCode == 400) {
          final decodedBody = utf8.decode(await checkResult.data!.stream.toBytes());
          final error = json.decode(decodedBody) as Map<String, dynamic>;

          if (error.containsKey('status_code') && error['status_code'] == 'rejected' && error.containsKey('substatus')) {
            switch (error['substatus']) {
              case 'incorrect_doc_type':
                result = DocumentDetectErrorType.errorIncorrectDocType;
                break;
              case 'margin_small':
                result = DocumentDetectErrorType.errorIncorrectDocType;
                break;
              case 'cant_detect_document':
                result = DocumentDetectErrorType.errorCantDetectDocument;
                break;
              case 'margin_big':
                result = DocumentDetectErrorType.errorMarginBig;
                break;
              case 'download_error':
                result = DocumentDetectErrorType.errorDownloadError;
                break;
              case 'unsupported_image_type':
                result = DocumentDetectErrorType.errorUnsupportedImageType;
                break;
              case 'resolution_small':
                result = DocumentDetectErrorType.errorResolutionSmall;
                break;
              case 'resolution_big':
                result = DocumentDetectErrorType.errorResolutionBig;
                break;
              case 'face_count_error':
                result = DocumentDetectErrorType.errorFaceCount;
                break;
              case 'blur_big':
                result = DocumentDetectErrorType.errorBlurBig;
                break;
              case 'brightness_small':
                result = DocumentDetectErrorType.errorBrightnessSmall;
                break;
              case 'brightness_big':
                result = DocumentDetectErrorType.errorBrightnessBig;
                break;
              case 'ocr_required_fields':
                result = DocumentDetectErrorType.errorOcrRequiredFields;
                break;
              case 'screenshot':
                result = DocumentDetectErrorType.errorScreenshot;
                break;
              case 'edited':
                result = DocumentDetectErrorType.errorEdited;
                break;
            }
          }
        } else {
          result = DocumentDetectErrorType.errorGeneral;
        }
      }

      tLog.d(tag, 'executeAsync, result: $result');
    } catch (e) {
      tLog.e(tag, e);
    }

    return Future.value(DocumentDetectError(timeStamp: DateTime.now(), type: result));
  }
}
