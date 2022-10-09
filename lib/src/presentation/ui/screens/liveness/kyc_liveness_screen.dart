import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:learning_input_image/learning_input_image.dart' as lii;

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/domain/entity/kyc_step.dart';
import 'package:multi_kyc_sdk/src/general/constants.dart';
import 'package:multi_kyc_sdk/src/presentation/store/screens/liveness/kyc_liveness_screen_store.dart';
import 'package:multi_kyc_sdk/src/presentation/ui/base/base_error_store_state.dart';
import 'package:multi_kyc_sdk/src/presentation/widgets/custom_face_overlay.dart';
import 'package:multi_kyc_sdk/src/presentation/widgets/input_camera_view.dart';

@internal
class KycLivenessScreen extends StatefulWidget {
  static const tag = 'KycScreen';

  final String secret;
  final KycStep step;

  const KycLivenessScreen({super.key, required this.secret, required this.step});

  @override
  _KycLivenessScreenState createState() {
    return _KycLivenessScreenState();
  }
}

class _KycLivenessScreenState extends BaseErrorStoreState<KycLivenessScreen, KycLivenessScreenStore> {
  @override
  void initState({void Function(Object? error, StackTrace? stack)? errorCallbackValue, dynamic data}) {
    super.initState(data: [widget.secret, widget.step]);
  }

  @override
  Widget buildContent(BuildContext context) {
    return InputCameraView(
      cameraDefault: InputCameraType.front,
      resolutionPreset: lii.ResolutionPreset.high,
      onImage: (imageValue, cameraImage) => store.detectFaces(imageValue, cameraImage),
      overlay: Observer(
        builder: (BuildContext context) {
          return Stack(
            children: [
              store.buildOverlayWidget(context),
              if (Constants.livenessDebugMode) ...[
                _buildCustomFaceOverlay(),
                //_buildDefaultFaceOverlay(),
                _buildInfoOverlay(),
                //_buildConvertedImage(),
              ],
            ],
          );
        },
      ),
    );
  }

  // ignore: unused_element
  Widget _buildConvertedImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 3,
              decoration: const BoxDecoration(color: Colors.red),
              child: store.imageJpg != null ? Image.memory(store.imageJpg!) : const SizedBox(),
            ),
          ],
        ),
      ],
    );
  }

  // ignore: unused_element
  Widget _buildInfoOverlay() {
    return Column(
      children: [
        Center(
          child: Text(
            store.selfieType.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 40.0,
              height: 48.0 / 40.0,
            ),
          ),
        ),
        if (store.selfieData != null) ...[
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(8),
            child: Text(
              'top: ${store.selfieData!.detectData.topHeadPadding ~/ 1}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                height: 24.0 / 18.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(8),
            child: Text(
              'bottom: ${store.selfieData!.detectData.bottomHeadPadding ~/ 1}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                height: 24.0 / 18.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(8),
            child: Text(
              'left: ${store.selfieData!.detectData.leftHeadPadding ~/ 1}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                height: 24.0 / 18.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(8),
            child: Text(
              'right: ${store.selfieData!.detectData.rightHeadPadding ~/ 1}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                height: 24.0 / 18.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(8),
            child: Text(
              'fillCenterHead: ${store.selfieData!.detectData.fillCenterHead ~/ 1}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                height: 24.0 / 18.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(8),
            child: Text(
              'leftDeviation: ${store.selfieData!.detectData.leftDeviationPercentage ~/ 1}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                height: 24.0 / 18.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(8),
            child: Text(
              'rightDeviation: ${store.selfieData!.detectData.rightDeviationPercentage ~/ 1}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                height: 24.0 / 18.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(8),
            child: Text(
              'topDeviation: ${store.selfieData!.detectData.topDeviationPercentage ~/ 1}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                height: 24.0 / 18.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(8),
            child: Text(
              'bottomDeviation: ${store.selfieData!.detectData.bottomDeviationPercentage ~/ 1}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                height: 24.0 / 18.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(8),
            child: Text(
              'headTilted: ${store.selfieData!.detectData.detectError.headTilted}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                height: 24.0 / 18.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(8),
            child: Text(
              'headFar: ${store.selfieData!.detectData.detectError.headFar}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                height: 24.0 / 18.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(8),
            child: Text(
              'headClose: ${store.selfieData!.detectData.detectError.headClose}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                height: 24.0 / 18.0,
              ),
            ),
          ),
        ],
      ],
    );
  }

  // // ignore: unused_element
  // Widget _buildDefaultFaceOverlay() {
  //   if (debugMode && store.data != null && store.image != null && store.image!.metadata != null) {
  //     final originalSize = store.image!.metadata!.size;
  //     final size = MediaQuery.of(context).size;
  //     final rotation = store.image!.metadata!.rotation;
  //
  //     return FaceOverlay(
  //       size: size,
  //       originalSize: originalSize,
  //       rotation: rotation,
  //       faces: store.data!,
  //       boundStroke: false,
  //       boundFill: false,
  //       contourColor: Colors.white.withOpacity(0.8),
  //       landmarkColor: Colors.lightBlue.withOpacity(0.8),
  //     );
  //   }
  //
  //   return Container();
  // }

  // ignore: unused_element
  Widget _buildCustomFaceOverlay() {
    if (Constants.livenessDebugMode && store.selfieData != null) {
      return CustomFaceOverlay(
        data: store.selfieData!,
        size: MediaQuery.of(context).size,
      );
    }

    return Container();
  }
}
