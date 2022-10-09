// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_entity_verification_status_get.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiEntityVerificationStatusGet _$ApiEntityVerificationStatusGetFromJson(
        Map<String, dynamic> json) =>
    ApiEntityVerificationStatusGet(
      secret: json['secret'] as String? ?? '',
      status: json['status'] as String? ?? '',
      step: json['step'] == null
          ? null
          : ApiEntityVerificationStatusStepGet.fromJson(
              json['step'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiEntityVerificationStatusGetToJson(
        ApiEntityVerificationStatusGet instance) =>
    <String, dynamic>{
      'secret': instance.secret,
      'status': instance.status,
      'step': instance.step,
    };
