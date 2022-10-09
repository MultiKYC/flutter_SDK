import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:learning_input_image/learning_input_image.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_document_type.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_source.dart';
import 'package:multi_kyc_sdk/src/domain/entity/kyc_step.dart';
import 'package:multi_kyc_sdk/src/presentation/store/screens/documents/documents_photo_screen_store.dart';
import 'package:multi_kyc_sdk/src/presentation/ui/base/base_error_store_state.dart';
import 'package:multi_kyc_sdk/src/presentation/widgets/input_camera_view.dart' as sdk;

@internal
class DocumentsPhotoScreen extends StatefulWidget {
  static const tag = 'DocumentsPhotoScreen';

  final String secret;
  final KycStep step;
  final DocumentDocumentType documentType;
  final DocumentSource documentSource;

  const DocumentsPhotoScreen({
    super.key,
    required this.secret,
    required this.step,
    required this.documentType,
    required this.documentSource,
  });

  @override
  _DocumentsPhotoScreenState createState() {
    return _DocumentsPhotoScreenState();
  }
}

class _DocumentsPhotoScreenState extends BaseErrorStoreState<DocumentsPhotoScreen, DocumentsPhotoScreenStore> {
  @override
  void initState({void Function(Object? error, StackTrace? stack)? errorCallbackValue, dynamic data}) {
    super.initState(data: [widget.secret, widget.step, widget.documentType, widget.documentSource]);
  }

  @override
  Widget buildContent(BuildContext context) {
    if (store.documentSource == DocumentSource.camera) {
      return sdk.InputCameraView(
        onImage: (imageValue, cameraImage) => store.processPhoto(imageValue, cameraImage),
        overlay: Observer(
          builder: (BuildContext context) {
            return Stack(
              children: [
                store.buildCameraOverlayWidget(context),
              ],
            );
          },
        ),
        resolutionPreset: ResolutionPreset.high,
      );
    } else {
      return store.buildSelectPhotoOverlayWidget(context);
    }
  }
}
