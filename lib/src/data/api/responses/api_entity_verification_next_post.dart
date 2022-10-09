// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'api_entity_verification_next_post.g.dart';

@JsonSerializable()
@internal
class ApiEntityVerificationNextPost {
  @JsonKey(name: 'status_code', defaultValue: '')
  final String statusCode;

  @JsonKey(name: 'status', defaultValue: '')
  final String status;

  ApiEntityVerificationNextPost({
    required this.statusCode,
    required this.status,
  });

  factory ApiEntityVerificationNextPost.fromJson(Map<String, dynamic> json) => _$ApiEntityVerificationNextPostFromJson(json);

  Map<String, dynamic> toJson() => _$ApiEntityVerificationNextPostToJson(this);
}
