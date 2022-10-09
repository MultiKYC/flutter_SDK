import 'package:injectable/injectable.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/data/api/responses/api_entity_verification_status_get.dart';
import 'package:multi_kyc_sdk/src/domain/entity/kyc_status.dart';
import 'package:multi_kyc_sdk/src/domain/entity/kyc_step.dart';
import 'package:multi_kyc_sdk/src/domain/entity/kyc_step_status.dart';
import 'package:multi_kyc_sdk/src/domain/entity/kyc_step_type.dart';
import 'package:multi_kyc_sdk/src/domain/entity/mapper/base/mapper.dart';

@LazySingleton()
@internal
class KycStatusMapper extends Mapper<ApiEntityVerificationStatusGet, KycStatus> {
  @override
  ApiEntityVerificationStatusGet reverseMap(KycStatus value) {
    throw Exception('Not supported');
  }

  @override
  KycStatus map(ApiEntityVerificationStatusGet value) {
    KycStep? step;

    if (value.step != null) {
      step = KycStep(
        id: value.step!.id,
        number: value.step!.number,
        metadata: null,
        stepType: _parseStepType(value.step!.type),
        status: _parseStatus(value.step!.status),
      );
    }

    return KycStatus(
      secret: value.secret,
      status: _parseStatus(value.status),
      step: step,
    );
  }

  KycStepType _parseStepType(String value) {
    switch (value) {
      case 'liveness':
        return KycStepType.liveness;
      case 'document':
        return KycStepType.document;
      default:
        return KycStepType.none;
    }
  }

  KycStepStatus _parseStatus(String value) {
    switch (value) {
      case 'new':
        return KycStepStatus.verificationNew;
      case 'in_progress':
        return KycStepStatus.verificationInProgress;
      case 'approved':
        return KycStepStatus.verificationApproved;
      case 'failed':
        return KycStepStatus.verificationApplicantFiled;
      case 'expired':
        return KycStepStatus.errorExpired;
      default:
        return KycStepStatus.errorKyc;
    }
  }
}
