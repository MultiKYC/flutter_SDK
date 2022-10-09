// ignore_for_file: depend_on_referenced_packages, implementation_imports

import 'dart:io';

import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_kyc_sdk/multi_kyc_sdk.dart' as kyc_sdk;

class TestDocumentSelectPhotoOverlayWidget extends StatefulWidget {
  final kyc_sdk.DocumentsState state;
  final kyc_sdk.DocumentDocumentPage? page;
  final Future<void> Function(XFile file) selectFile;
  final kyc_sdk.DocumentDetectError? error;
  final BuildContext baseContext;

  const TestDocumentSelectPhotoOverlayWidget({
    Key? key,
    required this.state,
    required this.page,
    required this.selectFile,
    required this.error,
    required this.baseContext,
  }) : super(key: key);

  @override
  _TestDocumentSelectPhotoOverlayWidgetState createState() {
    return _TestDocumentSelectPhotoOverlayWidgetState();
  }
}

class _TestDocumentSelectPhotoOverlayWidgetState extends State<TestDocumentSelectPhotoOverlayWidget> {
  final _picker = ImagePicker();
  XFile? _imageFile;
  bool _inProgress = false;

  bool get _isError => widget.error != null && widget.error!.type != kyc_sdk.DocumentDetectErrorType.none;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 3;
    final kyc_sdk.DocumentStatus? status =
        widget.state.pagesStatus.firstWhereOrNull((element) => element != kyc_sdk.DocumentStatus.success);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                children: [
                  Expanded(
                    flex: 0,
                    child: _buildPagePanel(),
                  ),
                  Expanded(
                    flex: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 32, bottom: 32),
                      child: Text(
                        _getMainText(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF141719),
                          fontWeight: FontWeight.w700,
                          fontSize: 24.0,
                          height: 28.0 / 24.0,
                          letterSpacing: 0.01,
                        ),
                      ),
                    ),
                  ),
                  if (status != null && _imageFile != null) ...[
                    Expanded(
                      flex: 0,
                      child: Container(
                        height: height,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _getColorFromStatus(status),
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.file(
                            File(_imageFile!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          height: height,
                          width: MediaQuery.of(context).size.width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              'assets/passport_place_holder.png',
                              fit: BoxFit.contain,
                              color: const Color(0xFFC0C8CC),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (_isError) ...[
                    Expanded(
                      flex: 0,
                      child: Padding(
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
                  ] else ...[
                    const Expanded(
                      flex: 0,
                      child: Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          'Make sure that:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF141719),
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            height: 20.0 / 16.0,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 0,
                      child: Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          'The text on the photo is clear and legible; The entire document fits into the photo.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF707B80),
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            height: 24.0 / 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const Expanded(child: SizedBox()),
                  if (_imageFile != null) ...[
                    Expanded(
                      flex: 0,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_inProgress) {
                            setState(() {
                              _inProgress = true;
                            });
                            await widget.selectFile(_imageFile!).whenComplete(() {
                              setState(() {
                                _inProgress = false;
                                _imageFile = null;
                              });
                            });
                          }
                        },
                        child: const Text('It looks good'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      flex: 0,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_inProgress) {
                            final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

                            setState(() {
                              _imageFile = image;
                            });
                          }
                        },
                        child: const Text('Upload another photo'),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      flex: 0,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_inProgress) {
                            final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

                            setState(() {
                              _imageFile = image;
                            });
                          }
                        },
                        child: const Text('Upload a photo'),
                      ),
                    ),
                  ]
                ],
              ),
            ),
            if (_inProgress) ...[
              Stack(
                children: [
                  Container(
                    color: const Color(0xFFFFFFFF).withOpacity(0.4),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              )
            ],
          ],
        ),
      ),
    );
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

  Widget _buildPagePanel() {
    if (widget.state.pagesStatus.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 16),
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
}
