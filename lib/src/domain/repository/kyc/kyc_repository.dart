import 'dart:math';

import 'package:flutter/painting.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/domain/entity/liveness/liveness_detect_data.dart';
import 'package:multi_kyc_sdk/src/domain/entity/liveness/selfie_data.dart';

@internal
abstract class KycRepository {
  Future<LivenessDetectData> detectSelfie({
    required Rect imageRect,
    required Rect headRect,
    required Rect noseRect,
    required Rect centerArea,
    required Point? nosePointLeft,
    required Point? nosePointRight,
    required Point? eyePointLeft,
    required Point? eyePointRight,
    bool skipHorizontal = true,
    bool skipVertical = true,
    SelfieData? centerFaceData,
  });
}
