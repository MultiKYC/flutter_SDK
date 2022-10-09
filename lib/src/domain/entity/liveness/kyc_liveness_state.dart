import 'package:multi_kyc_sdk/src/domain/entity/liveness/kyc_liveness_status.dart';

class KycLivenessState {
  final KycLivenessStatus selfCenter;
  final KycLivenessStatus selfLeft;
  final KycLivenessStatus selfRight;
  final KycLivenessStatus selfTop;
  final KycLivenessStatus selfBottom;
  final bool approved;

  KycLivenessState({
    required this.selfCenter,
    required this.selfLeft,
    required this.selfRight,
    required this.selfTop,
    required this.selfBottom,
    required this.approved,
  });

  factory KycLivenessState.empty() {
    return KycLivenessState(
      selfLeft: KycLivenessStatus.none,
      selfTop: KycLivenessStatus.none,
      selfCenter: KycLivenessStatus.none,
      selfRight: KycLivenessStatus.none,
      selfBottom: KycLivenessStatus.none,
      approved: false,
    );
  }

  KycLivenessState copy({
    KycLivenessStatus? selfCenterValue,
    KycLivenessStatus? selfLeftValue,
    KycLivenessStatus? selfRightValue,
    KycLivenessStatus? selfTopValue,
    KycLivenessStatus? selfBottomValue,
    bool? approvedValue,
  }) {
    return KycLivenessState(
      selfLeft: selfLeftValue ?? selfLeft,
      selfTop: selfTopValue ?? selfTop,
      selfCenter: selfCenterValue ?? selfCenter,
      selfRight: selfRightValue ?? selfRight,
      selfBottom: selfBottomValue ?? selfBottom,
      approved: approvedValue ?? approved,
    );
  }

  bool get success =>
      selfCenter == KycLivenessStatus.success &&
      selfLeft == KycLivenessStatus.success &&
      selfRight == KycLivenessStatus.success &&
      selfTop == KycLivenessStatus.success &&
      selfBottom == KycLivenessStatus.success;
}
