import 'package:injectable/injectable.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/data/api/responses/api_entity_verification_document_page.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_document_page.dart';
import 'package:multi_kyc_sdk/src/domain/entity/mapper/base/mapper.dart';

@LazySingleton()
@internal
class DocumentDocumentPageMapper extends Mapper<ApiEntityVerificationDocumentPage, DocumentDocumentPage> {
  @override
  ApiEntityVerificationDocumentPage reverseMap(DocumentDocumentPage value) {
    throw Exception('Not supported');
  }

  @override
  DocumentDocumentPage map(ApiEntityVerificationDocumentPage value) {
    return DocumentDocumentPage(
      id: value.id,
      code: value.code,
      name: value.name,
    );
  }
}
