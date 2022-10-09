import 'dart:async';
import 'dart:collection';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:camera/camera.dart';
import 'package:injectable/injectable.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/domain/repository/general/exception_handler.dart';
import 'package:multi_kyc_sdk/src/domain/repository/log/log.dart';
import 'package:multi_kyc_sdk/src/presentation/injection/configure_dependencies.dart';

@Singleton(as: ExceptionHandler)
@internal
class ExceptionHandlerImpl implements ExceptionHandler {
  static const tag = 'ExceptionHandlerImpl';

  final HashMap<String, ExceptionHandlerListener> _listeners = HashMap<String, ExceptionHandlerListener>();

  @override
  Future<void> processException(Object error, StackTrace? stack) async {
    // To avoid displaying the crash if not granted permission for camera. Causing on CryptoWithdrawQrScannerScreen
    if (error is CameraException && error.code == 'cameraPermission') {
      return Future.value();
    }

    final Log tLog = getIt<Log>();
    tLog.d(tag, 'processException, listeners counts: ${_listeners.length}');

    if (!await _handleInternalError(error)) {
      for (final item in _listeners.values) {
        item(error, stack);
      }
    }

    return Future.value();
  }

  @override
  Future<void> addListener(String tag, ExceptionHandlerListener listener) async {
    if (_listeners.containsKey(tag)) {
      _listeners.remove(tag);
    }

    _listeners.putIfAbsent(tag, () => listener);
    return Future.value();
  }

  @override
  Future<void> removeListener(String tag) async {
    if (_listeners.containsKey(tag)) {
      _listeners.remove(tag);
    }

    return Future.value();
  }

  @override
  bool shouldSendErrorToSentry(Object error) {
    if (error is TimeoutException || error is SocketException || error is HandshakeException) {
      return false;
    }

    return true;
  }

  Future<bool> _handleInternalError(Object error) async {
    return Future.value(false);
  }
}

typedef ExceptionHandlerListener = void Function(Object? error, StackTrace? stack);
