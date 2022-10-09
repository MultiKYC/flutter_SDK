// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_entity_verification_next_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiEntityVerificationNextPost _$ApiEntityVerificationNextPostFromJson(
        Map<String, dynamic> json) =>
    ApiEntityVerificationNextPost(
      statusCode: json['status_code'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );

Map<String, dynamic> _$ApiEntityVerificationNextPostToJson(
        ApiEntityVerificationNextPost instance) =>
    <String, dynamic>{
      'status_code': instance.statusCode,
      'status': instance.status,
    };
