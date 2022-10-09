import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:multi_kyc_sdk/src/domain/entity/liveness/liveness_detect_data.dart';

class SelfieData {
  final LivenessDetectData detectData;
  final Rect imageRect;
  final Rect headRect;
  final Rect noseRect;
  final Point eyePointLeft;
  final Point eyePointRight;
  final InputImageRotation rotation;

  SelfieData({
    required this.detectData,
    required this.imageRect,
    required this.headRect,
    required this.noseRect,
    required this.eyePointLeft,
    required this.eyePointRight,
    required this.rotation,
  });
}
