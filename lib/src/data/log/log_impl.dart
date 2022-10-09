import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/domain/repository/general/exception_handler.dart';
import 'package:multi_kyc_sdk/src/domain/repository/log/log.dart';

@LazySingleton(as: Log)
@internal
class LogImpl implements Log {
  final ExceptionHandler exceptionHandler;

  LogImpl(this.exceptionHandler);

  @override
  void d(String tag, String message) {
    debugPrint('DEBUG : $tag : $message');
  }

  @override
  void e(String tag, dynamic error, [dynamic stacktrace = '']) {
    debugPrint('ERROR : $tag : $error : $stacktrace');
  }
}
