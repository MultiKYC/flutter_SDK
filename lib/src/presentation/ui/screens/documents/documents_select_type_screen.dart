import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/sdk/kyc_sdk.dart';
import 'package:multi_kyc_sdk/src/domain/entity/documents/document_country.dart';
import 'package:multi_kyc_sdk/src/domain/entity/kyc_status.dart';
import 'package:multi_kyc_sdk/src/presentation/store/screens/documents/documents_select_type_screen_store.dart';
import 'package:multi_kyc_sdk/src/presentation/ui/base/base_error_store_state.dart';

@internal
class DocumentsSelectTypeScreen extends StatefulWidget {
  static const tag = 'DocumentsSelectTypeScreen';

  final KycStatus status;
  final DocumentSetUpScreenBuilder documentSetUpScreenBuilder;
  final DocumentRequestSource documentRequestSource;

  const DocumentsSelectTypeScreen({
    required this.status,
    required this.documentSetUpScreenBuilder,
    required this.documentRequestSource,
  });

  @override
  _DocumentsSelectTypeScreenState createState() {
    return _DocumentsSelectTypeScreenState();
  }
}

class _DocumentsSelectTypeScreenState extends BaseErrorStoreState<DocumentsSelectTypeScreen, DocumentsSelectTypeScreenStore> {
  @override
  void initState({void Function(Object? error, StackTrace? stack)? errorCallbackValue, dynamic data}) {
    super.initState(data: [widget.status, widget.documentRequestSource]);
  }

  @override
  Widget buildContent(BuildContext context) {
    return widget.documentSetUpScreenBuilder(context, widget.status.stepData as List<DocumentCountry>,
        (documentCountry, documentDocumentType) {
      store.selectDocument(context, documentCountry, documentDocumentType);
    });
  }
}
