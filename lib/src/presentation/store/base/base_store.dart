import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';
import 'package:multi_kyc_sdk/src/domain/repository/log/log.dart';
import 'package:multi_kyc_sdk/src/presentation/injection/configure_dependencies.dart';
import 'package:multi_kyc_sdk/src/presentation/store/base/base_store_state.dart';

@internal
typedef StoreCallback = Function();

@internal
abstract class BaseStore {
  final Log tLog = getIt<Log>();

  String get tag => runtimeType.toString();

  @observable
  BaseState _baseStoreState = BaseState.content;

  final _$baseStoreStateAtom = Atom(name: '_baseStoreStateAtom');

  BaseState get baseStoreState {
    _$baseStoreStateAtom.reportRead();
    return _baseStoreState;
  }

  set baseStoreState(BaseState value) {
    _$baseStoreStateAtom.reportWrite(value, _baseStoreState, () {
      _baseStoreState = value;
    });
  }

  bool _initialized = false;
  bool _disposed = false;

  //ignore:use_build_context_synchronously
  late BuildContext _context;

  Function(Object? error, StackTrace? stack)? errorCallback;

  //ignore:use_build_context_synchronously
  BuildContext get context => _context;

  bool get initialized {
    return _initialized;
  }

  bool get disposed {
    return _disposed;
  }

  void didChangeDependencies() {
    // no need to implement
  }

  void onLanguageChanged() {
    // no need to implement
  }

  Future<bool> dispose() {
    _disposed = true;
    return Future.value(true);
  }

  bool initStore(BuildContext context, void Function(Object? error, StackTrace? stack)? errorCallbackValue, {dynamic data}) {
    _initialized = true;
    _disposed = false;
    _context = context;
    errorCallback = errorCallbackValue;
    baseStoreState = BaseState.content;
    return true;
  }

  void closeKeyboard() {
    FocusScope.of(context).unfocus();
  }
}

@internal
typedef BoolCallback = void Function(bool value);
