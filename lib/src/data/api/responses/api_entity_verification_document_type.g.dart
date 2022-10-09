// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_entity_verification_document_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiEntityVerificationDocumentType _$ApiEntityVerificationDocumentTypeFromJson(
        Map<String, dynamic> json) =>
    ApiEntityVerificationDocumentType(
      id: json['id'] as int? ?? -1,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      pages: (json['pages'] as List<dynamic>)
          .map((e) => ApiEntityVerificationDocumentPage.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ApiEntityVerificationDocumentTypeToJson(
        ApiEntityVerificationDocumentType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'pages': instance.pages,
    };
