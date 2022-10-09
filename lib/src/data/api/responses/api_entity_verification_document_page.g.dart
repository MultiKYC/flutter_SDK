// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_entity_verification_document_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiEntityVerificationDocumentPage _$ApiEntityVerificationDocumentPageFromJson(
        Map<String, dynamic> json) =>
    ApiEntityVerificationDocumentPage(
      id: json['id'] as int? ?? -1,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );

Map<String, dynamic> _$ApiEntityVerificationDocumentPageToJson(
        ApiEntityVerificationDocumentPage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
    };
