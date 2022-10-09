// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/data/api/responses/api_entity_verification_document_page.dart';

part 'api_entity_verification_document_type.g.dart';

@JsonSerializable()
@internal
class ApiEntityVerificationDocumentType {
  @JsonKey(name: 'id', defaultValue: -1)
  final int id;

  @JsonKey(name: 'code', defaultValue: '')
  final String code;

  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  @JsonKey(name: 'pages')
  final List<ApiEntityVerificationDocumentPage> pages;

  ApiEntityVerificationDocumentType({
    required this.id,
    required this.code,
    required this.name,
    required this.pages,
  });

  factory ApiEntityVerificationDocumentType.fromJson(Map<String, dynamic> json) => _$ApiEntityVerificationDocumentTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ApiEntityVerificationDocumentTypeToJson(this);
}
