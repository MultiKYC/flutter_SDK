import 'package:multi_kyc_sdk/src/domain/entity/documents/document_document_page.dart';

class DocumentDocumentType {
  final int id;

  final String code;

  final String name;

  final List<DocumentDocumentPage> pages;

  DocumentDocumentType({
    required this.id,
    required this.code,
    required this.name,
    required this.pages,
  });
}
