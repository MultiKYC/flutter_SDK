import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kyc/config.dart';
import 'package:kyc/widgets/documents/test_document_camera_photo_overlay_widget.dart';
import 'package:kyc/widgets/documents/test_document_request_source_widget.dart';
import 'package:kyc/widgets/documents/test_document_select_photo_overlay_widget.dart';
import 'package:kyc/widgets/documents/test_document_type_select_widget.dart';
import 'package:kyc/widgets/liveness/test_liveness_overlay_widget.dart';
import 'package:kyc/widgets/liveness/test_sdk_error_widget.dart';
import 'package:multi_kyc_sdk/multi_kyc_sdk.dart' as kyc_sdk;
import 'package:wakelock/wakelock.dart';

class StepScreen extends StatefulWidget {
  static const tag = 'SplashScreen';

  @override
  _StepScreenState createState() {
    return _StepScreenState();
  }
}

class _StepScreenState extends State<StepScreen> {
  final _config = Config();
  kyc_sdk.KycSdk? _kycSdk;
  bool _loading = false;
  kyc_sdk.KycStepType? kycStepType;
  kyc_sdk.KycStepStatus? kycStepStatus;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: _buildContent(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: kycStepType != null && kycStepType != kyc_sdk.KycStepType.none
          ? SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Start step'),
                  ],
                ),
                onPressed: () {
                  _startNextStep();
                },
              ),
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Close'),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
    );
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
    });

    final applicantId = _config.applicantId;
    final kycUrl = _config.kycUrl;
    _kycSdk ??= kyc_sdk.KycSdk(
      applicant: kyc_sdk.Applicant(applicantId: applicantId, server: kycUrl),
      livenessCallback: (state) {
        // no need to handle
      },
      livenessOverlayBuilder: (
        BuildContext context,
        kyc_sdk.KycLivenessState state,
        kyc_sdk.LivenessDetectError? error,
        Size? fullAreaSize,
        Rect? centerArea,
      ) {
        return TestLivenessOverlayWidget(
          key: UniqueKey(),
          state: state,
          error: error,
          fullAreaSize: fullAreaSize,
          centerArea: centerArea,
        );
      },
      documentSetUpScreenBuilder: (context, countryList, finishCallback) {
        return TestDocumentTypeSelectWidget(
          finishCallback: finishCallback,
          countryList: countryList,
          baseContext: this.context,
        );
      },
      errorBuilder: (BuildContext context) {
        return const TestSdkErrorWidget();
      },
      documentRequestSource: (callback) {
        return TestDocumentRequestSourceWidget(context: context, finishCallback: callback).show();
      },
      documentsCameraPhotoOverlayBuilder: (
        BuildContext context,
        kyc_sdk.DocumentsState state,
        kyc_sdk.DocumentDocumentPage? page,
        Future<void> Function() makePhoto,
        kyc_sdk.DocumentDetectError? error,
        Size? uiAreaSize,
      ) {
        return TestDocumentCameraPhotoOverlayWidget(
          baseContext: context,
          state: state,
          page: page,
          makePhoto: makePhoto,
          error: error,
          uiAreaSize: uiAreaSize,
        );
      },
      documentsSelectPhotoOverlayBuilder: (
        BuildContext context,
        kyc_sdk.DocumentsState state,
        kyc_sdk.DocumentDocumentPage? page,
        Future<void> Function(XFile file) makePhoto,
        kyc_sdk.DocumentDetectError? error,
      ) {
        return TestDocumentSelectPhotoOverlayWidget(
          baseContext: context,
          state: state,
          page: page,
          selectFile: makePhoto,
          error: error,
        );
      },
      documentsPhotoCallback: (documentsState) {
        // no need to handle
      },
    );
    await _kycSdk!.initialize();
    kycStepType = await _kycSdk!.getNextStep();
    kycStepStatus = await _kycSdk!.checkStatus();

    if (kycStepType == null) {
      _showToast('Something wrong. Please try again.');
    }

    setState(() {
      _loading = false;
    });
  }

  void _startNextStep() {
    Wakelock.enable();
    _kycSdk!.startNextStep(context).whenComplete(() {
      Wakelock.disable();
      kycStepType = null;
      kycStepStatus = null;
      _loadData();
    });
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  Widget _buildContent() {
    if (_loading && kycStepType == null) {
      return const Center(
        child: SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(8),
            child: Text(
              'Next step is: ${kycStepType!.name}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(8),
            child: Text(
              'Current status: ${kycStepStatus?.name ?? ''}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    }
  }
}
