// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'api_entity_verification_document_country.g.dart';

@JsonSerializable()
@internal
class ApiEntityVerificationDocumentCountry {
  @JsonKey(name: 'id', defaultValue: -1)
  final int id;

  @JsonKey(name: 'code', defaultValue: '')
  final String code;

  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  ApiEntityVerificationDocumentCountry({
    required this.id,
    required this.code,
    required this.name,
  });

  factory ApiEntityVerificationDocumentCountry.fromJson(Map<String, dynamic> json) => _$ApiEntityVerificationDocumentCountryFromJson(json);

  Map<String, dynamic> toJson() => _$ApiEntityVerificationDocumentCountryToJson(this);
}
