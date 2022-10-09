// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/sdk/kyc_sdk.dart';
import 'package:multi_kyc_sdk/src/domain/entity/applicant.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/documents_state.dart';
import 'package:multi_kyc_sdk/src/domain/entity/liveness/kyc_liveness_state.dart';

@internal
abstract class ConfigureRepository {
  Applicant get applicant;

  Function(KycLivenessState)? get livenessCallback;

  Future<void> Function()? get livenessFinishCallback;

  LivenessOverlayBuilder? get livenessOverlayBuilder;

  DocumentSetUpScreenBuilder? get documentSetUpScreenBuilder;

  DocumentRequestSource? get documentRequestSource;

  DocumentsCameraPhotoOverlayBuilder? get documentsCameraPhotoOverlayBuilder;

  DocumentsFilePhotoOverlayBuilder? get documentsSelectPhotoOverlayBuilder;

  Function(DocumentsState)? get documentsPhotoCallback;

  ErrorBuilder? get errorBuilder;

  void initialize({
    required Applicant applicant,
    required Function(KycLivenessState)? livenessCallback,
    required LivenessOverlayBuilder? livenessOverlayBuilder,
    required Future<void> Function()? livenessFinishCallback,
    required DocumentSetUpScreenBuilder? documentSetUpScreenBuilder,
    required DocumentRequestSource? documentRequestSource,
    required DocumentsCameraPhotoOverlayBuilder? documentsCameraPhotoOverlayBuilder,
    required DocumentsFilePhotoOverlayBuilder? documentsSelectPhotoOverlayBuilder,
    required Function(DocumentsState)? documentsPhotoCallback,
    required ErrorBuilder? errorBuilder,
  });
}
