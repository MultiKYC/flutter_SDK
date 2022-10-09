import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';
import 'package:multi_kyc_sdk/sdk/kyc_sdk.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_country.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_document_type.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_source.dart';
import 'package:multi_kyc_sdk/src/domain/entity/kyc_status.dart';
import 'package:multi_kyc_sdk/src/general/log_helper.dart';
import 'package:multi_kyc_sdk/src/presentation/store/base/base_store.dart';

part 'documents_select_type_screen_store.g.dart';

@LazySingleton()
@internal
class DocumentsSelectTypeScreenStore = _DocumentsSelectTypeScreenStore with _$DocumentsSelectTypeScreenStore;

abstract class _DocumentsSelectTypeScreenStore extends BaseStore with Store, LogHelper {
  late KycStatus status;
  late DocumentRequestSource documentRequestSource;

  _DocumentsSelectTypeScreenStore();

  DocumentCountry? _selectedDocument;
  DocumentDocumentType? _selectedDocumentType;

  @override
  bool initStore(BuildContext context, void Function(Object? error, StackTrace? stack)? errorCallbackValue, {dynamic data}) {
    final bool result = super.initStore(context, errorCallbackValue, data: data);
    if (data is List) {
      status = data[0] as KycStatus;
      documentRequestSource = data[1] as DocumentRequestSource;
    }

    return result;
  }

  @action
  Future<void> selectDocument(BuildContext context, DocumentCountry document, DocumentDocumentType documentType) async {
    _selectedDocument = document;
    _selectedDocumentType = documentType;

    await selectDocumentSource(context).then((value) {
      if (value != null) {
        final result = [_selectedDocument, _selectedDocumentType, value];
        Navigator.of(context).pop(result);
      }
    });
  }

  @action
  Future<DocumentSource?> selectDocumentSource(BuildContext context) async {
    DocumentSource? source;
    await documentRequestSource.call((DocumentSource documentSource) {
      source = documentSource;
    });
    return Future.value(source);
  }
}
