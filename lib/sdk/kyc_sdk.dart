import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:multi_kyc_sdk/src/domain/entity/applicant.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_country.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_detect_error.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_document_page.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_document_type.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_source.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/documents_state.dart';
import 'package:multi_kyc_sdk/src/domain/entity/kyc_status.dart';
import 'package:multi_kyc_sdk/src/domain/entity/kyc_step_status.dart';
import 'package:multi_kyc_sdk/src/domain/entity/kyc_step_type.dart';
import 'package:multi_kyc_sdk/src/domain/entity/liveness/kyc_liveness_state.dart';
import 'package:multi_kyc_sdk/src/domain/entity/liveness/liveness_detect_error.dart';
import 'package:multi_kyc_sdk/src/domain/repository/general/configure_repository.dart';
import 'package:multi_kyc_sdk/src/domain/usecases/get_kyc_status.dart';
import 'package:multi_kyc_sdk/src/presentation/injection/configure_dependencies.dart';
import 'package:multi_kyc_sdk/src/presentation/store/base/base_store_state.dart';
import 'package:multi_kyc_sdk/src/presentation/ui/screens/documents/documents_photo_screen.dart';
import 'package:multi_kyc_sdk/src/presentation/ui/screens/documents/documents_select_type_screen.dart';
import 'package:multi_kyc_sdk/src/presentation/ui/screens/liveness/kyc_liveness_screen.dart';

typedef LivenessOverlayBuilder = Widget Function(
  BuildContext context,
  KycLivenessState state,
  LivenessDetectError? error,
  Size? fullAreaSize,
  Rect? centerArea,
);
typedef DocumentSetUpScreenBuilder = Widget Function(
  BuildContext context,
  List<DocumentCountry> countryList,
  DocumentSetUpScreenBuilderCallback finishCallback,
);
typedef DocumentsCameraPhotoOverlayBuilder = Widget Function(
  BuildContext context,
  DocumentsState state,
  DocumentDocumentPage? page,
  Future<void> Function() makePhoto,
  DocumentDetectError? error,
  Size? uiAreaSize,
);
typedef DocumentsFilePhotoOverlayBuilder = Widget Function(
  BuildContext context,
  DocumentsState state,
  DocumentDocumentPage? page,
  Future<void> Function(XFile file) makePhoto,
  DocumentDetectError? error,
);
typedef DocumentSetUpScreenBuilderCallback = void Function(DocumentCountry, DocumentDocumentType);
typedef DocumentRequestSource = Future Function(DocumentRequestSourceCallback callback);
typedef DocumentRequestSourceCallback = void Function(DocumentSource documentSource);
typedef ErrorBuilder = Widget Function(BuildContext context);

class KycSdk {
  static const tag = 'KycSdk';
  static bool _getItInitialized = false;

  /// Init parameters for SDK
  final Applicant applicant;

  /// Callback that intended for provide current state of liveness process
  final Function(KycLivenessState)? livenessCallback;

  /// Callback that raised when liveness process success finished
  final Future<void> Function()? livenessFinishCallback;

  /// Intended to provide the info overlay UI during liveness process
  final LivenessOverlayBuilder? livenessOverlayBuilder;

  /// Intended to provide the UI for select type of document
  final DocumentSetUpScreenBuilder? documentSetUpScreenBuilder;

  /// Intended to provide the UI for select source of document (file or camera)
  final DocumentRequestSource? documentRequestSource;

  /// Intended to provide the info overlay UI during making photo of document
  final DocumentsCameraPhotoOverlayBuilder? documentsCameraPhotoOverlayBuilder;

  /// Intended to provide the info overlay UI during making photo of document
  final DocumentsFilePhotoOverlayBuilder? documentsSelectPhotoOverlayBuilder;

  /// Callback that intended for provide current state of photo check
  final Function(DocumentsState)? documentsPhotoCallback;

  /// Intended to provide the UI with error info
  final ErrorBuilder? errorBuilder;

  KycSdk({
    required this.applicant,
    this.livenessCallback,
    this.livenessFinishCallback,
    this.livenessOverlayBuilder,
    this.documentSetUpScreenBuilder,
    this.documentRequestSource,
    this.documentsCameraPhotoOverlayBuilder,
    this.documentsSelectPhotoOverlayBuilder,
    this.documentsPhotoCallback,
    this.errorBuilder,
  });

  /// Initializes SDK. Should be call before use SDK.
  Future<void> initialize() async {
    try {
      if (!_getItInitialized) {
        if (kReleaseMode) {
          await configureDependencies(Environment.prod);
        } else {
          await configureDependencies(Environment.dev);
        }
        _getItInitialized = true;
      }
    } catch (e) {
      // no need to log
    }

    await GetIt.instance.allReady();

    final configureRepository = getIt<ConfigureRepository>();
    configureRepository.initialize(
      applicant: applicant,
      livenessCallback: livenessCallback,
      livenessFinishCallback: livenessFinishCallback,
      livenessOverlayBuilder: livenessOverlayBuilder,
      documentSetUpScreenBuilder: documentSetUpScreenBuilder,
      documentRequestSource: documentRequestSource,
      documentsCameraPhotoOverlayBuilder: documentsCameraPhotoOverlayBuilder,
      documentsSelectPhotoOverlayBuilder: documentsSelectPhotoOverlayBuilder,
      documentsPhotoCallback: documentsPhotoCallback,
      errorBuilder: errorBuilder,
    );

    return Future.value();
  }

  /// Returns current status of KYC process
  Future<KycStepStatus> checkStatus() async {
    final getKycStatus = getIt<GetKycStatus>();

    final result = await getKycStatus.executeAsync().onError((error, stackTrace) {
      if (error is TimeoutException || error is SocketException || error is ClientException || error is HandshakeException) {
        return KycStatus.errorConnection();
      } else {
        return KycStatus.errorGeneral();
      }
    });

    return result.status;
  }

  /// Returns next step for KYC process
  Future<KycStepType> getNextStep() async {
    final getKycStatus = getIt<GetKycStatus>();

    final result = await getKycStatus.executeAsync().onError((error, stackTrace) {
      if (error is TimeoutException || error is SocketException || error is ClientException || error is HandshakeException) {
        return KycStatus.errorConnection();
      } else {
        return KycStatus.errorGeneral();
      }
    });

    return Future.value(result.step?.stepType ?? KycStepType.none);
  }

  /// Start next step of KYC process
  Future<KycStepStatus> startNextStep(BuildContext context) async {
    final getKycStatus = getIt<GetKycStatus>();
    final status = await getKycStatus.executeAsync().onError((error, stackTrace) {
      if (error is TimeoutException || error is SocketException || error is ClientException || error is HandshakeException) {
        return KycStatus.errorConnection();
      } else {
        return KycStatus.errorGeneral();
      }
    });

    if (status.status == KycStepStatus.verificationApproved ||
        status.status == KycStepStatus.errorKyc ||
        status.status == KycStepStatus.errorConnection ||
        status.status == KycStepStatus.errorGeneral ||
        status.status == KycStepStatus.errorStepNotSupported ||
        status.status == KycStepStatus.errorExpired) {
      return Future.value(status.status);
    } else {
      if (status.step == null) {
        return Future.value(KycStepStatus.errorKyc);
      } else {
        return _processNextStep(context, status);
      }
    }
  }

  Future<KycStepStatus> _processNextStep(BuildContext context, KycStatus status) {
    switch (status.step!.stepType) {
      case KycStepType.none:
        return Future.value(KycStepStatus.errorKyc);
      case KycStepType.liveness:
        return _processLivenessStep(context, status);
      case KycStepType.document:
        return _processDocumentStep(context, status);
    }
  }

  Future<KycStepStatus> _processLivenessStep(BuildContext context, KycStatus status) async {
    final data = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => KycLivenessScreen(
          step: status.step!,
          secret: status.secret,
        ),
      ),
    );

    if (data == true) {
      final getKycStatus = getIt<GetKycStatus>();
      final result = await getKycStatus.executeAsync();
      return Future.value(result.status);
    } else {
      return KycStepStatus.verificationCanceled;
    }
  }

  Future<KycStepStatus> _processDocumentStep(BuildContext context, KycStatus status) async {
    if (status.stepData != null && status.stepData is List<DocumentCountry>) {
      final data = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => DocumentsSelectTypeScreen(
            status: status,
            documentSetUpScreenBuilder: documentSetUpScreenBuilder ??
                (context, countryList, finishCallback) {
                  return const SizedBox();
                },
            documentRequestSource: documentRequestSource ??
                (callback) {
                  return Future.value();
                },
          ),
        ),
      );

      if (data != null && data is List && data.length == 3) {
        final DocumentDocumentType selectedDocumentType = data[1] as DocumentDocumentType;
        final DocumentSource documentSource = data[2] as DocumentSource;
        final dataPhoto = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => DocumentsPhotoScreen(
              secret: status.secret,
              step: status.step!,
              documentType: selectedDocumentType,
              documentSource: documentSource,
            ),
          ),
        );

        if (dataPhoto == true) {
          final getKycStatus = getIt<GetKycStatus>();
          final result = await getKycStatus.executeAsync();
          return result.status;
        } else {
          return KycStepStatus.verificationCanceled;
        }
      } else {
        return KycStepStatus.verificationCanceled;
      }
    } else {
      return Future.value(KycStepStatus.errorKyc);
    }
  }
}
