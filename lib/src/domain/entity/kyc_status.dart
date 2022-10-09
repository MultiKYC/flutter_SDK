import 'package:multi_kyc_sdk/src/domain/entity/kyc_step.dart';
import 'package:multi_kyc_sdk/src/domain/entity/kyc_step_status.dart';

class KycStatus {
  final String secret;
  final KycStepStatus status;
  final KycStep? step;
  final dynamic stepData;

  KycStatus({
    required this.secret,
    required this.status,
    required this.step,
    this.stepData,
  });

  KycStatus cloneWithStepData(dynamic stepData) {
    return KycStatus(secret: secret, status: status, step: step, stepData: stepData);
  }

  factory KycStatus.errorKyc() {
    return KycStatus(secret: '', status: KycStepStatus.errorKyc, step: null);
  }

  factory KycStatus.errorGeneral() {
    return KycStatus(secret: '', status: KycStepStatus.errorGeneral, step: null);
  }

  factory KycStatus.errorConnection() {
    return KycStatus(secret: '', status: KycStepStatus.errorConnection, step: null);
  }
}
