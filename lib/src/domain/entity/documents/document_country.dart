import 'package:multi_kyc_sdk/src/domain/entity/documents/document_document_type.dart';

class DocumentCountry {
  final int id;

  final String code;

  final String name;

  final List<DocumentDocumentType> documents = [];

  DocumentCountry({
    required this.id,
    required this.code,
    required this.name,
  });
}
