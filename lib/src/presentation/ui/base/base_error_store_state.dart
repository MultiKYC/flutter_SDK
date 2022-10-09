// ignore_for_file: unused_field

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/domain/repository/general/configure_repository.dart';
import 'package:multi_kyc_sdk/src/presentation/injection/configure_dependencies.dart';
import 'package:multi_kyc_sdk/src/presentation/store/base/base_store.dart';
import 'package:multi_kyc_sdk/src/presentation/store/base/base_store_state.dart';
import 'package:multi_kyc_sdk/src/presentation/ui/base/base_store_state.dart';

@internal
abstract class BaseErrorStoreState<T extends StatefulWidget, S extends BaseStore> extends BaseStoreState<T, S> {
  final _configureRepository = getIt<ConfigureRepository>();

  Object? _error;
  StackTrace? _stack;

  @override
  void initState({void Function(Object? error, StackTrace? stack)? errorCallbackValue, dynamic data}) {
    super.initState(errorCallbackValue: errorCallbackValue ?? handleError, data: data);
  }

  void handleError(Object? error, StackTrace? stack) {
    if (!mounted) {
      return;
    }

    _error = error;
    _stack = stack;

    BaseState updatedState = BaseState.content;

    if (error is TimeoutException || error is SocketException || error is ClientException || error is HandshakeException) {
      updatedState = BaseState.errorConnection;
    } else {
      // for any not detected errors display general error screen
      updatedState = BaseState.errorGeneral;
    }

    if (updatedState != store.baseStoreState) {
      store.baseStoreState = updatedState;
    }
  }

  @nonVirtual
  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final content = Observer(
      builder: (BuildContext context) {
        switch (store.baseStoreState) {
          case BaseState.content:
            return buildContent(context);
          case BaseState.errorConnection:
            return _configureRepository.errorBuilder != null
                ? _configureRepository.errorBuilder!(context)
                : const SizedBox();
          case BaseState.errorGeneral:
          default:
            return _configureRepository.errorBuilder != null
                ? _configureRepository.errorBuilder!(context)
                : const SizedBox();
        }
      },
    );

    return WillPopScope(
      onWillPop: () async {
        return onBackPressed();
      },
      child: MediaQuery(
        data: mediaQueryData.copyWith(textScaleFactor: 1.0),
        child: content,
      ),
    );
  }

  Future<bool> onBackPressed() {
    return Future.value(true);
  }

  Widget buildContent(BuildContext context);
}
