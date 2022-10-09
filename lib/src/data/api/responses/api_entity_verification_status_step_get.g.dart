// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_entity_verification_status_step_get.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiEntityVerificationStatusStepGet _$ApiEntityVerificationStatusStepGetFromJson(
        Map<String, dynamic> json) =>
    ApiEntityVerificationStatusStepGet(
      id: json['id'] as int? ?? -1,
      number: json['number'] as int? ?? -1,
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );

Map<String, dynamic> _$ApiEntityVerificationStatusStepGetToJson(
        ApiEntityVerificationStatusStepGet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'name': instance.name,
      'status': instance.status,
      'type': instance.type,
    };
