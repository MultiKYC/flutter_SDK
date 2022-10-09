import 'package:multi_kyc_sdk/src/domain/entity/documents/document_detect_error_type.dart';

class DocumentDetectError {
  final DateTime timeStamp;
  final DocumentDetectErrorType type;

  DocumentDetectError({
    required this.timeStamp,
    required this.type,
  });

  @override
  bool operator ==(Object other) {
    if (other is DocumentDetectError) {
      return timeStamp == other.timeStamp && type == other.type;
    } else {
      return super == other;
    }
  }

  @override
  int get hashCode => type.hashCode + timeStamp.hashCode;
}
