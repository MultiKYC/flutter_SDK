import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart' as ml;
import 'package:learning_input_image/learning_input_image.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

@internal
enum InputCameraMode { live, gallery }

@internal
enum InputCameraType { front, rear }

@internal
class InputCameraView extends StatefulWidget {
  const InputCameraView({
    super.key,
    this.overlay,
    this.mode = InputCameraMode.live,
    this.cameraDefault = InputCameraType.rear,
    this.resolutionPreset = ResolutionPreset.low,
    required this.onImage,
  });

  final Widget? overlay;
  final InputCameraMode mode;
  final InputCameraType cameraDefault;
  final ResolutionPreset resolutionPreset;
  final Function(ml.InputImage inputImage, CameraImage image) onImage;

  @override
  _InputCameraViewState createState() => _InputCameraViewState();
}

class _InputCameraViewState extends State<InputCameraView> {
  CameraController? _controller;
  int _cameraIndex = 0;

  CameraDescription get camera => cameras[_cameraIndex];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeCamera();
      await _startLiveStream();
      _refresh();
    });
  }

  @override
  void dispose() {
    _stopLiveStream();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();

    if (cameras.length > 1 && widget.cameraDefault == InputCameraType.front) {
      _cameraIndex = 1;
    }
  }

  Future<void> _startLiveStream() async {
    _controller = CameraController(
      camera,
      widget.resolutionPreset,
      enableAudio: false,
    );

    await _controller?.initialize();
    _controller?.startImageStream(_processImage);
    _refresh();
  }

  Future<void> _stopLiveStream() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future<void> _processImage(CameraImage image) async {
    late ml.InputImageRotation rotation;

    switch (camera.sensorOrientation) {
      case 0:
        rotation = ml.InputImageRotation.rotation0deg;
        break;
      case 90:
        rotation = ml.InputImageRotation.rotation90deg;
        break;
      case 180:
        rotation = ml.InputImageRotation.rotation180deg;
        break;
      case 270:
        rotation = ml.InputImageRotation.rotation270deg;
        break;
    }

    final writer = WriteBuffer();
    for (final plane in image.planes) {
      writer.putUint8List(plane.bytes);
    }

    final inputImage = ml.InputImage.fromBytes(
      bytes: writer.done().buffer.asUint8List(),
      inputImageData: ml.InputImageData(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        imageRotation: rotation,
        inputImageFormat: ml.InputImageFormat.yuv420,
        planeData: null,
      ),
    );

    widget.onImage(inputImage, image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _buildCameraView()),
    );
  }

  Widget _buildCameraView() {
    if (_controller != null && _controller!.value.isInitialized) {
      return ColoredBox(
        color: Colors.black,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            IgnorePointer(child: CameraPreview(_controller!)),
            widget.overlay ?? Container(),
          ],
        ),
      );
    }

    return Container();
  }
}
