// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_photo_screen_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DocumentsPhotoScreenStore on _DocumentsPhotoScreenStore, Store {
  final _$_stateAtom = Atom(name: '_DocumentsPhotoScreenStore._state');

  @override
  DocumentsState get _state {
    _$_stateAtom.reportRead();
    return super._state;
  }

  @override
  set _state(DocumentsState value) {
    _$_stateAtom.reportWrite(value, super._state, () {
      super._state = value;
    });
  }

  final _$processPhotoAsyncAction =
      AsyncAction('_DocumentsPhotoScreenStore.processPhoto');

  @override
  Future<void> processPhoto(
      ml.InputImage imageValue, CameraImage cameraImageValue) {
    return _$processPhotoAsyncAction
        .run(() => super.processPhoto(imageValue, cameraImageValue));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
