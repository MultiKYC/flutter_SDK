// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'api_entity_verification_status_step_get.g.dart';

@JsonSerializable()
@internal
class ApiEntityVerificationStatusStepGet {
  @JsonKey(name: 'id', defaultValue: -1)
  final int id;

  @JsonKey(name: 'number', defaultValue: -1)
  final int number;

  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  @JsonKey(name: 'status', defaultValue: '')
  final String status;

  @JsonKey(name: 'type', defaultValue: '')
  final String type;

  ApiEntityVerificationStatusStepGet({
    required this.id,
    required this.number,
    required this.name,
    required this.status,
    required this.type,
  });

  factory ApiEntityVerificationStatusStepGet.fromJson(Map<String, dynamic> json) => _$ApiEntityVerificationStatusStepGetFromJson(json);

  Map<String, dynamic> toJson() => _$ApiEntityVerificationStatusStepGetToJson(this);
}
