import 'package:injectable/injectable.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/data/api/responses/api_entity_verification_document_country.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_country.dart';
import 'package:multi_kyc_sdk/src/domain/entity/mapper/base/mapper.dart';

@LazySingleton()
@internal
class DocumentCountryMapper extends Mapper<ApiEntityVerificationDocumentCountry, DocumentCountry> {
  @override
  ApiEntityVerificationDocumentCountry reverseMap(DocumentCountry value) {
    throw Exception('Not supported');
  }

  @override
  DocumentCountry map(ApiEntityVerificationDocumentCountry value) {
    return DocumentCountry(
      id: value.id,
      code: value.code,
      name: value.name,
    );
  }
}
