import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart' as ml;
import 'package:injectable/injectable.dart';
import 'package:learning_input_image/learning_input_image.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';
import 'package:multi_kyc_sdk/src/domain/entity/kyc_step.dart';
import 'package:multi_kyc_sdk/src/domain/entity/liveness/kyc_liveness_state.dart';
import 'package:multi_kyc_sdk/src/domain/entity/liveness/kyc_liveness_status.dart';
import 'package:multi_kyc_sdk/src/domain/entity/liveness/selfie_data.dart';
import 'package:multi_kyc_sdk/src/domain/entity/liveness/selfie_type.dart';
import 'package:multi_kyc_sdk/src/domain/repository/general/configure_repository.dart';
import 'package:multi_kyc_sdk/src/domain/repository/helper/image_helper.dart';
import 'package:multi_kyc_sdk/src/domain/usecases/check_selfie_data.dart';
import 'package:multi_kyc_sdk/src/domain/usecases/detect_selfie_data.dart';
import 'package:multi_kyc_sdk/src/domain/usecases/upload_selfie_data.dart';
import 'package:multi_kyc_sdk/src/general/constants.dart';
import 'package:multi_kyc_sdk/src/general/log_helper.dart';
import 'package:multi_kyc_sdk/src/presentation/injection/configure_dependencies.dart';
import 'package:multi_kyc_sdk/src/presentation/store/base/base_store.dart';

part 'kyc_liveness_screen_store.g.dart';

@LazySingleton()
@internal
class KycLivenessScreenStore = _KycScreenStore with _$KycLivenessScreenStore;

abstract class _KycScreenStore extends BaseStore with Store, LogHelper {
  final _detectSelfieData = getIt<DetectSelfieData>();
  final _configureRepository = getIt<ConfigureRepository>();
  final _uploadSelfieData = getIt<UploadSelfieData>();
  final _checkSelfieData = getIt<CheckSelfieData>();
  final _imageHelper = getIt<ImageHelper>();

  ml.FaceDetector? _detector;

  bool _processing = false;

  ml.InputImage? image;

  @observable
  Uint8List? imageJpg;

  @observable
  ui.Image? imageUi;

  @observable
  List<ml.Face>? data;

  @observable
  SelfieData? selfieData;

  @observable
  SelfieType selfieType = SelfieType.none;

  @observable
  KycLivenessState kycLivenessState = KycLivenessState.empty();

  Size? _fullAreaSize;
  Rect? _centerArea;

  // data of the center image
  SelfieData? _centerSelfieData;
  int _countDetectedCenterEvents = 0;

  late String secret;
  late KycStep step;

  DateTime? _lastDetectCallTime;

  _KycScreenStore();

  @override
  bool initStore(BuildContext context, void Function(Object? error, StackTrace? stack)? errorCallbackValue, {dynamic data}) {
    final bool result = super.initStore(context, errorCallbackValue, data: data);

    image = null;
    this.data = null;
    selfieData = null;
    _centerSelfieData = null;
    _countDetectedCenterEvents = 0;
    kycLivenessState = KycLivenessState.empty();
    selfieType = SelfieType.none;

    if (data != null) {
      final List dataList = data as List;
      secret = dataList[0] as String;
      step = dataList[1] as KycStep;
    }

    final faceDetectorOptions = ml.FaceDetectorOptions(
      enableLandmarks: true,
      enableContours: true,
      performanceMode: ml.FaceDetectorMode.accurate,
    );
    _detector = ml.FaceDetector(options: faceDetectorOptions);

    return result;
  }

  @override
  Future<bool> dispose() async {
    await _detector?.close();
    _detector = null;
    _processing = false;
    return Future.value(true);
  }

  @action
  Future<void> detectFaces(ml.InputImage imageValue, CameraImage cameraImage) async {
    if (_checkBounce()) {
      return;
    }

    _lastDetectCallTime = DateTime.now();

    if (!_processing && _detector != null && !kycLivenessState.approved) {
      _processing = true;
      final screenWidth = MediaQuery.of(context).size.width;
      _fullAreaSize = Size(screenWidth, screenWidth * (imageValue.inputImageData!.size.width / imageValue.inputImageData!.size.height));
      _centerArea = _getCenterArea(_fullAreaSize!);
      image = imageValue;

      if (Constants.livenessDebugMode && image != null && image!.bytes != null) {
        final List<int>? bytes = await _imageHelper
            .convertNv21ToJpg(cameraImage, imageValue.inputImageData?.imageRotation ?? ml.InputImageRotation.rotation0deg)
            .onError((error, stackTrace) {
          errorCallback?.call(error, stackTrace);
          return null;
        });

        if (bytes != null) {
          imageJpg = Uint8List.fromList(bytes);
        }
      }

      data = await _detector!.processImage(image!);
      final bool skipHorizontal = !(kycLivenessState.selfCenter == KycLivenessStatus.success ||
          kycLivenessState.selfLeft != KycLivenessStatus.success ||
          kycLivenessState.selfRight != KycLivenessStatus.success);
      final bool skipVertical = !(kycLivenessState.selfCenter == KycLivenessStatus.success ||
          kycLivenessState.selfTop != KycLivenessStatus.success ||
          kycLivenessState.selfBottom != KycLivenessStatus.success);
      selfieData = await _detectSelfieData.executeAsync(
        _fullAreaSize!,
        _centerArea!,
        image!,
        data!,
        skipHorizontal,
        skipVertical,
        _centerSelfieData,
      );
      selfieType = selfieData?.detectData.selfieType ?? SelfieType.none;

      // process next image
      if (selfieData != null) {
        switch (selfieType) {
          case SelfieType.none:
            // no need process
            break;
          case SelfieType.center:
            _countDetectedCenterEvents++;

            if (_countDetectedCenterEvents > Constants.countCenterEventsToStart) {
              await _processImageCenter(imageValue, cameraImage, selfieData!);
            }
            break;
          case SelfieType.top:
            await _processImageTop(imageValue, cameraImage, selfieData!);
            break;
          case SelfieType.bottom:
            await _processImageBottom(imageValue, cameraImage, selfieData!);
            break;
          case SelfieType.left:
            await _processImageLeft(imageValue, cameraImage, selfieData!);
            break;
          case SelfieType.right:
            await _processImageRight(imageValue, cameraImage, selfieData!);
            break;
        }
      }

      // check is finished
      if (kycLivenessState.success) {
        final checkSelfieResult = await _checkSelfieData.executeAsync(secret, step);

        if (checkSelfieResult) {
          kycLivenessState = kycLivenessState.copy(approvedValue: true);
          _configureRepository.livenessCallback?.call(kycLivenessState);

          if (_configureRepository.livenessFinishCallback != null) {
            await _configureRepository.livenessFinishCallback!.call();
          }
          Navigator.of(context).pop(true);
        } else {
          Navigator.of(context).pop(false);
        }
      }

      _processing = false;
    }
  }

  Widget buildOverlayWidget(BuildContext context) {
    return _configureRepository.livenessOverlayBuilder != null
        ? _configureRepository.livenessOverlayBuilder!(
            context,
            kycLivenessState,
            selfieData?.detectData.detectError,
            _fullAreaSize,
            _centerArea,
          )
        : const SizedBox();
  }

  Future _processImageCenter(ml.InputImage image, CameraImage cameraImage, SelfieData selfieData) async {
    if (kycLivenessState.selfCenter == KycLivenessStatus.none) {
      kycLivenessState = kycLivenessState.copy(selfCenterValue: KycLivenessStatus.progress);
      _configureRepository.livenessCallback?.call(kycLivenessState);

      await _uploadSelfieData.executeAsync(secret, step, image, cameraImage, SelfieType.center).then((value) {
        if (value) {
          _centerSelfieData = selfieData;
          kycLivenessState = kycLivenessState.copy(selfCenterValue: KycLivenessStatus.success);
        } else {
          _centerSelfieData = null;
          _countDetectedCenterEvents = 0;
          kycLivenessState = kycLivenessState.copy(selfCenterValue: KycLivenessStatus.none);
        }
        _configureRepository.livenessCallback?.call(kycLivenessState);
      }).onError((error, stackTrace) {
        errorCallback?.call(error, stackTrace);
      });
    }

    return Future.value();
  }

  Future _processImageLeft(ml.InputImage image, CameraImage cameraImage, SelfieData selfieData) async {
    if (kycLivenessState.selfCenter == KycLivenessStatus.success && kycLivenessState.selfLeft == KycLivenessStatus.none) {
      kycLivenessState = kycLivenessState.copy(selfLeftValue: KycLivenessStatus.progress);
      _configureRepository.livenessCallback?.call(kycLivenessState);

      await _uploadSelfieData.executeAsync(secret, step, image, cameraImage, SelfieType.left).then((value) {
        if (value) {
          kycLivenessState = kycLivenessState.copy(selfLeftValue: KycLivenessStatus.success);
        } else {
          kycLivenessState = kycLivenessState.copy(selfLeftValue: KycLivenessStatus.none);
        }
        _configureRepository.livenessCallback?.call(kycLivenessState);
      }).onError((error, stackTrace) {
        errorCallback?.call(error, stackTrace);
      });
    }

    return Future.value();
  }

  Future _processImageRight(ml.InputImage image, CameraImage cameraImage, SelfieData selfieData) async {
    if (kycLivenessState.selfCenter == KycLivenessStatus.success && kycLivenessState.selfRight == KycLivenessStatus.none) {
      kycLivenessState = kycLivenessState.copy(selfRightValue: KycLivenessStatus.progress);
      _configureRepository.livenessCallback?.call(kycLivenessState);

      await _uploadSelfieData.executeAsync(secret, step, image, cameraImage, SelfieType.right).then((value) {
        if (value) {
          kycLivenessState = kycLivenessState.copy(selfRightValue: KycLivenessStatus.success);
        } else {
          kycLivenessState = kycLivenessState.copy(selfRightValue: KycLivenessStatus.none);
        }
        _configureRepository.livenessCallback?.call(kycLivenessState);
      }).onError((error, stackTrace) {
        errorCallback?.call(error, stackTrace);
      });
    }

    return Future.value();
  }

  Future _processImageTop(ml.InputImage image, CameraImage cameraImage, SelfieData selfieData) async {
    if (kycLivenessState.selfCenter == KycLivenessStatus.success && kycLivenessState.selfTop == KycLivenessStatus.none) {
      kycLivenessState = kycLivenessState.copy(selfTopValue: KycLivenessStatus.progress);
      _configureRepository.livenessCallback?.call(kycLivenessState);

      await _uploadSelfieData.executeAsync(secret, step, image, cameraImage, SelfieType.top).then((value) {
        if (value) {
          kycLivenessState = kycLivenessState.copy(selfTopValue: KycLivenessStatus.success);
        } else {
          kycLivenessState = kycLivenessState.copy(selfTopValue: KycLivenessStatus.none);
        }
        _configureRepository.livenessCallback?.call(kycLivenessState);
      }).onError((error, stackTrace) {
        errorCallback?.call(error, stackTrace);
      });
    }

    return Future.value();
  }

  Future _processImageBottom(ml.InputImage image, CameraImage cameraImage, SelfieData selfieData) async {
    if (kycLivenessState.selfCenter == KycLivenessStatus.success && kycLivenessState.selfBottom == KycLivenessStatus.none) {
      kycLivenessState = kycLivenessState.copy(selfBottomValue: KycLivenessStatus.progress);
      _configureRepository.livenessCallback?.call(kycLivenessState);

      await _uploadSelfieData.executeAsync(secret, step, image, cameraImage, SelfieType.bottom).then((value) {
        if (value) {
          kycLivenessState = kycLivenessState.copy(selfBottomValue: KycLivenessStatus.success);
        } else {
          kycLivenessState = kycLivenessState.copy(selfBottomValue: KycLivenessStatus.none);
        }
        _configureRepository.livenessCallback?.call(kycLivenessState);
      }).onError((error, stackTrace) {
        errorCallback?.call(error, stackTrace);
      });
    }

    return Future.value();
  }

  bool _checkBounce() {
    if ((DateTime.now().millisecondsSinceEpoch - (_lastDetectCallTime?.millisecondsSinceEpoch ?? 0)) < Constants.livenessBounceValue) {
      return true;
    } else {
      return false;
    }
  }

  Rect _getCenterArea(Size fullSize) {
    final width = _fullAreaSize!.width * 0.8;
    final height = _fullAreaSize!.height * 0.7;
    final offsetX = (_fullAreaSize!.width * 0.2) / 2;
    final offsetY = (_fullAreaSize!.height * 0.3) / 2;
    return Rect.fromLTWH(offsetX, offsetY, width, height);
  }
}
