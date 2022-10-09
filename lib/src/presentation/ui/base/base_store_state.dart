import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/presentation/injection/configure_dependencies.dart';
import 'package:multi_kyc_sdk/src/presentation/store/base/base_store.dart';

@internal
abstract class BaseStoreState<T extends StatefulWidget, S extends BaseStore> extends State<T> with WidgetsBindingObserver {
  String get tag => runtimeType.toString();

  S get store => getIt<S>();

  AppLifecycleState? appLifecycleState;

  @override
  void initState({void Function(Object? error, StackTrace? stack)? errorCallbackValue, dynamic data}) {
    super.initState();
    store.initStore(context, errorCallbackValue, data: data);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    store.dispose();

    if (mounted) {
      super.dispose();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    store.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (mounted && state != appLifecycleState) {
      appLifecycleState = state;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onAppLifecycleStateChanged(appLifecycleState);
      });
    }
  }

  void onAppLifecycleStateChanged(AppLifecycleState? state) {
    // no need to implement
  }

  /// Helper method for change focus
  void fieldFocusChange(BuildContext context, FocusNode? currentFocus, FocusNode? nextFocus) {
    if (currentFocus != null) {
      currentFocus.unfocus();
    }

    if (nextFocus != null) {
      FocusScope.of(context).requestFocus(nextFocus);
    }
  }

  /// Helper method for hide keyboard
  void hideKeyboard(BuildContext context) {
    try {
      if (mounted) {
        FocusScope.of(context).unfocus();
      }
    } catch (e) {
      // skip all error related with focus
    }
  }
}
