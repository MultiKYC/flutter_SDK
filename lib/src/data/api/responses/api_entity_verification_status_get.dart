// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/data/api/responses/api_entity_verification_status_step_get.dart';

part 'api_entity_verification_status_get.g.dart';

@JsonSerializable()
@internal
class ApiEntityVerificationStatusGet {
  @JsonKey(name: 'secret', defaultValue: '')
  final String secret;

  @JsonKey(name: 'status', defaultValue: '')
  final String status;

  @JsonKey(name: 'step', defaultValue: null)
  final ApiEntityVerificationStatusStepGet? step;

  ApiEntityVerificationStatusGet({
    required this.secret,
    required this.status,
    this.step,
  });

  factory ApiEntityVerificationStatusGet.fromJson(Map<String, dynamic> json) => _$ApiEntityVerificationStatusGetFromJson(json);

  Map<String, dynamic> toJson() => _$ApiEntityVerificationStatusGetToJson(this);
}
