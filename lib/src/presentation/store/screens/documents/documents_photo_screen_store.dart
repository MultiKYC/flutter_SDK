// ignore_for_file: depend_on_referenced_packages, implementation_imports

import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart' as ml;
import 'package:injectable/injectable.dart';
import 'package:learning_input_image/learning_input_image.dart';
import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_detect_error.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_detect_error_type.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_document_type.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_source.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_status.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/documents_state.dart';
import 'package:multi_kyc_sdk/src/domain/entity/kyc_step.dart';
import 'package:multi_kyc_sdk/src/domain/repository/general/configure_repository.dart';
import 'package:multi_kyc_sdk/src/domain/usecases/check_selfie_data.dart';
import 'package:multi_kyc_sdk/src/domain/usecases/upload_document_from_camera.dart';
import 'package:multi_kyc_sdk/src/domain/usecases/upload_document_from_file.dart';
import 'package:multi_kyc_sdk/src/general/log_helper.dart';
import 'package:multi_kyc_sdk/src/presentation/injection/configure_dependencies.dart';
import 'package:multi_kyc_sdk/src/presentation/store/base/base_store.dart';

part 'documents_photo_screen_store.g.dart';

@LazySingleton()
@internal
class DocumentsPhotoScreenStore = _DocumentsPhotoScreenStore with _$DocumentsPhotoScreenStore;

abstract class _DocumentsPhotoScreenStore extends BaseStore with Store, LogHelper {
  final _configureRepository = getIt<ConfigureRepository>();
  final _uploadDocumentFromCamera = getIt<UploadDocumentFromCamera>();
  final _uploadDocumentFromFile = getIt<UploadDocumentFromFile>();
  final _checkSelfieData = getIt<CheckSelfieData>();

  bool _processing = false;
  bool _requestPhoto = false;

  ml.InputImage? image;
  CameraImage? cameraImage;

  late String secret;
  late KycStep step;
  late DocumentDocumentType documentType;
  late DocumentSource documentSource;

  DocumentDetectError? _detectedError;

  @observable
  DocumentsState _state = DocumentsState.empty();

  Size? _uiAreaSize;

  _DocumentsPhotoScreenStore();

  @override
  bool initStore(BuildContext context, void Function(Object? error, StackTrace? stack)? errorCallbackValue, {dynamic data}) {
    final bool result = super.initStore(context, errorCallbackValue, data: data);
    _state = DocumentsState.empty();
    _detectedError = null;

    if (data != null) {
      final List dataList = data as List;
      secret = dataList[0] as String;
      step = dataList[1] as KycStep;
      documentType = dataList[2] as DocumentDocumentType;
      documentSource = dataList[3] as DocumentSource;

      if (documentType.pages.isNotEmpty) {
        final List<DocumentStatus> pagesStatus = [];

        for (int i = 0; i < documentType.pages.length; i++) {
          pagesStatus.add(DocumentStatus.none);
        }

        _state = _state.copy(pagesStatusValue: pagesStatus);
      }
    }

    return result;
  }

  @override
  Future<bool> dispose() async {
    _processing = false;
    _requestPhoto = false;
    _detectedError = null;
    return Future.value(true);
  }

  @action
  Future<void> processPhoto(ml.InputImage imageValue, CameraImage cameraImageValue) async {
    if (!_processing && _requestPhoto) {
      final screenWidth = MediaQuery.of(context).size.width;
      _uiAreaSize = Size(screenWidth, screenWidth * (imageValue.inputImageData!.size.width / imageValue.inputImageData!.size.height));
      _requestPhoto = false;
      _processing = true;
      image = imageValue;
      cameraImage = cameraImageValue;

      final pageStatus = _state.pagesStatus.firstWhereOrNull((element) => element == DocumentStatus.none);
      final pageIndex = pageStatus != null ? _state.pagesStatus.indexOf(pageStatus) : -1;

      if (pageIndex != -1 && image != null && cameraImage != null) {
        await _processCameraPage(image!, cameraImage!, pageIndex);

        // check is finished
        if (_state.success) {
          final checkSelfieResult = await _checkSelfieData.executeAsync(secret, step);

          if (checkSelfieResult) {
            _state = _state.copy(approvedValue: true);
            Navigator.of(context).pop(true);
          } else {
            Navigator.of(context).pop(false);
          }
        }
      }

      _processing = false;
    }
  }

  Future<void> _makePhotoFromCamera() async {
    if (!_processing) {
      _requestPhoto = true;
    }
  }

  Future<void> _makePhotoFromFile(XFile file) async {
    if (!_processing) {
      _processing = true;
      _detectedError = null;

      final pageStatus = _state.pagesStatus.firstWhereOrNull((element) => element == DocumentStatus.none);
      final pageIndex = pageStatus != null ? _state.pagesStatus.indexOf(pageStatus) : -1;

      if (pageIndex != -1) {
        await _processFilePage(file, pageIndex);

        // check is finished
        if (_state.success) {
          final checkSelfieResult = await _checkSelfieData.executeAsync(secret, step);

          if (checkSelfieResult) {
            _state = _state.copy(approvedValue: true);
            Navigator.of(context).pop(true);
          } else {
            Navigator.of(context).pop(false);
          }
        }
      }

      _processing = false;
    }
  }

  Widget buildCameraOverlayWidget(BuildContext context) {
    final pageStatus = _state.pagesStatus.firstWhereOrNull((element) => element != DocumentStatus.success);
    final pageIndex = pageStatus != null ? _state.pagesStatus.indexOf(pageStatus) : -1;
    final page = pageIndex == -1 ? null : documentType.pages[pageIndex];
    return _configureRepository.documentsCameraPhotoOverlayBuilder != null
        ? _configureRepository.documentsCameraPhotoOverlayBuilder!(context, _state, page, _makePhotoFromCamera, _detectedError, _uiAreaSize)
        : const SizedBox();
  }

  Widget buildSelectPhotoOverlayWidget(BuildContext context) {
    final pageStatus = _state.pagesStatus.firstWhereOrNull((element) => element != DocumentStatus.success);
    final pageIndex = pageStatus != null ? _state.pagesStatus.indexOf(pageStatus) : -1;
    final page = pageIndex == -1 ? null : documentType.pages[pageIndex];
    return _configureRepository.documentsSelectPhotoOverlayBuilder != null
        ? _configureRepository.documentsSelectPhotoOverlayBuilder!(context, _state, page, _makePhotoFromFile, _detectedError)
        : const SizedBox();
  }

  Future _processFilePage(XFile file, int pageIndex) async {
    final page = documentType.pages[pageIndex];
    final List<DocumentStatus> pagesStatus = _state.pagesStatus;
    pagesStatus[pageIndex] = DocumentStatus.progress;
    _state = _state.copy(pagesStatusValue: pagesStatus);
    _detectedError = null;
    _configureRepository.documentsPhotoCallback?.call(_state);

    await _uploadDocumentFromFile.executeAsync(secret, step, file, page).then((value) {
      final List<DocumentStatus> pagesStatus = _state.pagesStatus;

      if (value.type == DocumentDetectErrorType.none) {
        pagesStatus[pageIndex] = DocumentStatus.success;
        _configureRepository.documentsPhotoCallback?.call(_state);
      } else {
        _detectedError = value;
        pagesStatus[pageIndex] = DocumentStatus.none;
        _configureRepository.documentsPhotoCallback?.call(_state);
      }

      _state = _state.copy(pagesStatusValue: pagesStatus);
      _configureRepository.documentsPhotoCallback?.call(_state);
    }).onError((error, stackTrace) {
      errorCallback?.call(error, stackTrace);
    });

    return Future.value();
  }

  Future _processCameraPage(ml.InputImage image, CameraImage cameraImage, int pageIndex) async {
    final page = documentType.pages[pageIndex];
    final List<DocumentStatus> pagesStatus = _state.pagesStatus;
    pagesStatus[pageIndex] = DocumentStatus.progress;
    _state = _state.copy(pagesStatusValue: pagesStatus);
    _detectedError = null;
    _configureRepository.documentsPhotoCallback?.call(_state);

    await _uploadDocumentFromCamera.executeAsync(secret, step, image, cameraImage, page).then((value) {
      final List<DocumentStatus> pagesStatus = _state.pagesStatus;

      if (value.type == DocumentDetectErrorType.none) {
        pagesStatus[pageIndex] = DocumentStatus.success;
        _configureRepository.documentsPhotoCallback?.call(_state);
      } else {
        _detectedError = value;
        pagesStatus[pageIndex] = DocumentStatus.none;
        _configureRepository.documentsPhotoCallback?.call(_state);
      }

      _state = _state.copy(pagesStatusValue: pagesStatus);
      _configureRepository.documentsPhotoCallback?.call(_state);
    }).onError((error, stackTrace) {
      errorCallback?.call(error, stackTrace);
    });

    return Future.value();
  }
}
