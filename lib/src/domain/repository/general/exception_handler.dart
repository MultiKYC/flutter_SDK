// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/domain/exception/exception_handler_impl.dart';

@internal
abstract class ExceptionHandler {
  Future<void> processException(Object error, StackTrace? stack);

  Future<void> addListener(String tag, ExceptionHandlerListener listener);

  Future<void> removeListener(String tag);

  bool shouldSendErrorToSentry(Object error);
}
