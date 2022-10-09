import 'package:injectable/injectable.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/sdk/kyc_sdk.dart';
import 'package:multi_kyc_sdk/src/domain/entity/applicant.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/documents_state.dart';
import 'package:multi_kyc_sdk/src/domain/entity/liveness/kyc_liveness_state.dart';
import 'package:multi_kyc_sdk/src/domain/repository/general/configure_repository.dart';
import 'package:multi_kyc_sdk/src/general/log_helper.dart';

@LazySingleton(as: ConfigureRepository)
@internal
class ConfigureRepositoryImpl with LogHelper implements ConfigureRepository {
  static const tag = 'ConfigureRepositoryImpl';

  late Applicant _applicant;

  late Function(KycLivenessState)? _livenessCallback;

  late Future<void> Function()? _livenessFinishCallback;

  late LivenessOverlayBuilder? _livenessOverlayBuilder;

  late DocumentSetUpScreenBuilder? _documentSetUpScreenBuilder;

  late DocumentRequestSource? _documentRequestSource;

  late DocumentsCameraPhotoOverlayBuilder? _documentsCameraPhotoOverlayBuilder;

  late DocumentsFilePhotoOverlayBuilder? _documentsSelectPhotoOverlayBuilder;

  late Function(DocumentsState)? _documentsPhotoCallback;

  late ErrorBuilder? _errorBuilder;

  @override
  Applicant get applicant => _applicant;

  @override
  Function(KycLivenessState p1)? get livenessCallback => _livenessCallback;

  @override
  Future<void> Function()? get livenessFinishCallback => _livenessFinishCallback;

  @override
  LivenessOverlayBuilder? get livenessOverlayBuilder => _livenessOverlayBuilder;

  @override
  DocumentSetUpScreenBuilder? get documentSetUpScreenBuilder => _documentSetUpScreenBuilder;

  @override
  DocumentRequestSource? get documentRequestSource => _documentRequestSource;

  @override
  DocumentsCameraPhotoOverlayBuilder? get documentsCameraPhotoOverlayBuilder => _documentsCameraPhotoOverlayBuilder;

  @override
  DocumentsFilePhotoOverlayBuilder? get documentsSelectPhotoOverlayBuilder => _documentsSelectPhotoOverlayBuilder;

  @override
  Function(DocumentsState)? get documentsPhotoCallback => _documentsPhotoCallback;

  @override
  ErrorBuilder? get errorBuilder => _errorBuilder;

  @override
  void initialize({
    required Applicant applicant,
    required Function(KycLivenessState)? livenessCallback,
    required Future<void> Function()? livenessFinishCallback,
    required LivenessOverlayBuilder? livenessOverlayBuilder,
    required DocumentSetUpScreenBuilder? documentSetUpScreenBuilder,
    required DocumentRequestSource? documentRequestSource,
    required DocumentsCameraPhotoOverlayBuilder? documentsCameraPhotoOverlayBuilder,
    required DocumentsFilePhotoOverlayBuilder? documentsSelectPhotoOverlayBuilder,
    required Function(DocumentsState)? documentsPhotoCallback,
    required ErrorBuilder? errorBuilder,
  }) {
    _applicant = applicant;
    _livenessCallback = livenessCallback;
    _livenessFinishCallback = livenessFinishCallback;
    _livenessOverlayBuilder = livenessOverlayBuilder;
    _documentSetUpScreenBuilder = documentSetUpScreenBuilder;
    _documentRequestSource = documentRequestSource;
    _documentsCameraPhotoOverlayBuilder = documentsCameraPhotoOverlayBuilder;
    _documentsSelectPhotoOverlayBuilder = documentsSelectPhotoOverlayBuilder;
    _documentsPhotoCallback = documentsPhotoCallback;
    _errorBuilder = errorBuilder;
  }
}
