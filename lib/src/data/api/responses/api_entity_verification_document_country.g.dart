// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_entity_verification_document_country.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiEntityVerificationDocumentCountry
    _$ApiEntityVerificationDocumentCountryFromJson(Map<String, dynamic> json) =>
        ApiEntityVerificationDocumentCountry(
          id: json['id'] as int? ?? -1,
          code: json['code'] as String? ?? '',
          name: json['name'] as String? ?? '',
        );

Map<String, dynamic> _$ApiEntityVerificationDocumentCountryToJson(
        ApiEntityVerificationDocumentCountry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
    };
