import 'dart:typed_data';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart' as ml;
import 'package:learning_input_image/learning_input_image.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

@internal
abstract class ImageHelper {
  Future<Uint8List?> convertNv21ToJpg(CameraImage image, ml.InputImageRotation rotation);
}
