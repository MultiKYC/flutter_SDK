import 'package:multi_kyc_sdk/src/domain/entity/documents/document_status.dart';

class DocumentsState {
  final List<DocumentStatus> pagesStatus;
  final bool approved;

  DocumentsState({
    required this.pagesStatus,
    required this.approved,
  });

  factory DocumentsState.empty() {
    return DocumentsState(
      pagesStatus: [],
      approved: false,
    );
  }

  DocumentsState copy({
    List<DocumentStatus>? pagesStatusValue,
    bool? approvedValue,
  }) {
    return DocumentsState(
      pagesStatus: pagesStatusValue ?? pagesStatus,
      approved: approvedValue ?? approved,
    );
  }

  bool get success {
    for (final item in pagesStatus) {
      if (item != DocumentStatus.success) {
        return false;
      }
    }

    return true;
  }
}
