import 'package:injectable/injectable.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/data/api/responses/api_entity_verification_document_type.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_document_type.dart';
import 'package:multi_kyc_sdk/src/domain/entity/mapper/base/mapper.dart';
import 'package:multi_kyc_sdk/src/domain/entity/mapper/documents/document_document_page_mapper.dart';
import 'package:multi_kyc_sdk/src/presentation/injection/configure_dependencies.dart';

@LazySingleton()
@internal
class DocumentDocumentTypeMapper extends Mapper<ApiEntityVerificationDocumentType, DocumentDocumentType> {
  final _documentDocumentPageMapper = getIt<DocumentDocumentPageMapper>();

  @override
  ApiEntityVerificationDocumentType reverseMap(DocumentDocumentType value) {
    throw Exception('Not supported');
  }

  @override
  DocumentDocumentType map(ApiEntityVerificationDocumentType value) {
    final pages = _documentDocumentPageMapper.mapList(value.pages);

    return DocumentDocumentType(
      id: value.id,
      code: value.code,
      name: value.name,
      pages: pages,
    );
  }
}
