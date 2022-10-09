import 'package:multi_kyc_sdk/src/domain/entity/kyc_step_status.dart';
import 'package:multi_kyc_sdk/src/domain/entity/kyc_step_type.dart';

class KycStep {
  final int id;
  final int number;
  final KycStepType stepType;
  final KycStepStatus status;
  final Object? metadata;

  KycStep({
    required this.id,
    required this.number,
    required this.stepType,
    required this.status,
    required this.metadata,
  });
}
