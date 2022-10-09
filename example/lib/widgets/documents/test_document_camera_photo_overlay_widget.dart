// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:multi_kyc_sdk/multi_kyc_sdk.dart' as kyc_sdk;

class TestDocumentCameraPhotoOverlayWidget extends StatefulWidget {
  final kyc_sdk.DocumentsState state;
  final kyc_sdk.DocumentDocumentPage? page;
  final void Function() makePhoto;
  final kyc_sdk.DocumentDetectError? error;
  final BuildContext baseContext;
  final Size? uiAreaSize;

  const TestDocumentCameraPhotoOverlayWidget({
    Key? key,
    required this.state,
    required this.page,
    required this.makePhoto,
    required this.error,
    required this.baseContext,
    required this.uiAreaSize,
  }) : super(key: key);

  @override
  _TestDocumentCameraPhotoOverlayWidgetState createState() {
    return _TestDocumentCameraPhotoOverlayWidgetState();
  }
}

class _TestDocumentCameraPhotoOverlayWidgetState extends State<TestDocumentCameraPhotoOverlayWidget> {
  bool get _isError => widget.error != null && widget.error!.type != kyc_sdk.DocumentDetectErrorType.none;

  @override
  Widget build(BuildContext context) {
    final height = widget.uiAreaSize == null ? MediaQuery.of(context).size.height / 3 : widget.uiAreaSize!.height / 3;
    final kyc_sdk.DocumentStatus? status =
        widget.state.pagesStatus.firstWhereOrNull((element) => element != kyc_sdk.DocumentStatus.success);

    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.5),
      appBar: AppBar(
        titleSpacing: 0.0,
        bottom: PreferredSize(
          preferredSize: Size.zero,
          child: _buildPagePanel(),
        ),
        elevation: 0,
        centerTitle: false,
        leadingWidth: 40,
        backgroundColor: Colors.black.withOpacity(0.5),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Expanded(
              flex: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.only(top: 32, bottom: 32),
                child: Text(
                  _getMainText(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w700,
                    fontSize: 24.0,
                    height: 28.0 / 24.0,
                    letterSpacing: 0.01,
                  ),
                ),
              ),
            ),
            if (status != null) ...[
              Center(
                child: SizedBox(
                  height: height,
                  child: Row(
                    children: [
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        width: 16,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: _getColorFromStatus(status),
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        width: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            Expanded(
              flex: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _getErrorText(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFDA3725),
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    height: 24.0 / 16.0,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildMakePhotoButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildMakePhotoButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(80),
        border: Border.all(
          width: 4,
          color: Colors.white,
        ),
      ),
      child: InkWell(
        onTap: () {
          widget.makePhoto.call();
          setState(() {});
        },
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(56),
            child: Container(
              height: 56,
              width: 56,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPagePanel() {
    if (widget.state.pagesStatus.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(left: 5, right: 5, top: 20),
        child: Row(
          children: widget.state.pagesStatus
              .map(
                (item) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    height: 4,
                    decoration: BoxDecoration(
                      color: _getColorFromStatus(item),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Color _getColorFromStatus(kyc_sdk.DocumentStatus status) {
    switch (status) {
      case kyc_sdk.DocumentStatus.none:
        return const Color(0xFFDCE2E5);
      case kyc_sdk.DocumentStatus.progress:
        return const Color(0xFF00C777).withOpacity(0.5);
      case kyc_sdk.DocumentStatus.success:
        return const Color(0xFF00C777);
      case kyc_sdk.DocumentStatus.error:
        return const Color(0xFFFE5B3A);
    }
  }

  String _getMainText() {
    final code = widget.page?.code ?? '';

    switch (code) {
      case 'ua_id_01':
        return 'The first page of the passport';
      case 'ua_id_02':
        return 'The second page of the passport';
      default:
        return '';
    }
  }

  String _getErrorText() {
    if (_isError) {
      switch (widget.error!.type) {
        case kyc_sdk.DocumentDetectErrorType.none:
          return '';
        case kyc_sdk.DocumentDetectErrorType.errorGeneral:
          return 'Document not recognized';
        case kyc_sdk.DocumentDetectErrorType.errorIncorrectDocType:
          return 'The passed document type does not match the actual document type';
        case kyc_sdk.DocumentDetectErrorType.errorCantDetectDocument:
          return 'Unable to find document';
        case kyc_sdk.DocumentDetectErrorType.errorMarginSmall:
          return 'The margin from the edge of the document to the edge of the image is very small';
        case kyc_sdk.DocumentDetectErrorType.errorMarginBig:
          return 'The margin from the edge of the document to the edge of the image is too large';
        case kyc_sdk.DocumentDetectErrorType.errorDownloadError:
          return 'Internal error, unable to download photo';
        case kyc_sdk.DocumentDetectErrorType.errorUnsupportedImageType:
          return 'Image format not supported';
        case kyc_sdk.DocumentDetectErrorType.errorResolutionSmall:
          return 'Resolution is very small';
        case kyc_sdk.DocumentDetectErrorType.errorResolutionBig:
          return 'Resolution is very high';
        case kyc_sdk.DocumentDetectErrorType.errorFaceCount:
          return 'Number of persons more than one';
        case kyc_sdk.DocumentDetectErrorType.errorBlurBig:
          return 'Blur is very high';
        case kyc_sdk.DocumentDetectErrorType.errorBrightnessSmall:
          return 'Brightness is very low';
        case kyc_sdk.DocumentDetectErrorType.errorBrightnessBig:
          return 'Brightness is very high';
        case kyc_sdk.DocumentDetectErrorType.errorOcrRequiredFields:
          return 'Required field not recognized';
        case kyc_sdk.DocumentDetectErrorType.errorScreenshot:
          return 'Screenshot detected';
        case kyc_sdk.DocumentDetectErrorType.errorEdited:
          return 'Processed by graphic editor';
      }
    } else {
      return '';
    }
  }
}
