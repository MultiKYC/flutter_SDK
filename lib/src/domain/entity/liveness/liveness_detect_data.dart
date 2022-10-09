import 'package:multi_kyc_sdk/src/domain/entity/liveness/liveness_detect_error.dart';
import 'package:multi_kyc_sdk/src/domain/entity/liveness/selfie_type.dart';

class LivenessDetectData {
  final SelfieType selfieType;
  final double topHeadPadding;
  final double bottomHeadPadding;
  final double leftHeadPadding;
  final double rightHeadPadding;
  final double fillCenterHead;
  final double leftDeviationPercentage;
  final double rightDeviationPercentage;
  final double topDeviationPercentage;
  final double bottomDeviationPercentage;
  final LivenessDetectError detectError;

  LivenessDetectData({
    required this.selfieType,
    required this.topHeadPadding,
    required this.bottomHeadPadding,
    required this.leftHeadPadding,
    required this.rightHeadPadding,
    required this.fillCenterHead,
    required this.leftDeviationPercentage,
    required this.rightDeviationPercentage,
    required this.topDeviationPercentage,
    required this.bottomDeviationPercentage,
    required this.detectError,
  });
}
