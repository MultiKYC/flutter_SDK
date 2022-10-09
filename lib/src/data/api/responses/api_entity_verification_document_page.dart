// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'api_entity_verification_document_page.g.dart';

@JsonSerializable()
@internal
class ApiEntityVerificationDocumentPage {
  @JsonKey(name: 'id', defaultValue: -1)
  final int id;

  @JsonKey(name: 'code', defaultValue: '')
  final String code;

  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  ApiEntityVerificationDocumentPage({
    required this.id,
    required this.code,
    required this.name,
  });

  factory ApiEntityVerificationDocumentPage.fromJson(Map<String, dynamic> json) => _$ApiEntityVerificationDocumentPageFromJson(json);

  Map<String, dynamic> toJson() => _$ApiEntityVerificationDocumentPageToJson(this);
}
