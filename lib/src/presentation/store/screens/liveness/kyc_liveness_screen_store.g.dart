// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_liveness_screen_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$KycLivenessScreenStore on _KycScreenStore, Store {
  final _$imageJpgAtom = Atom(name: '_KycScreenStore.imageJpg');

  @override
  Uint8List? get imageJpg {
    _$imageJpgAtom.reportRead();
    return super.imageJpg;
  }

  @override
  set imageJpg(Uint8List? value) {
    _$imageJpgAtom.reportWrite(value, super.imageJpg, () {
      super.imageJpg = value;
    });
  }

  final _$imageUiAtom = Atom(name: '_KycScreenStore.imageUi');

  @override
  ui.Image? get imageUi {
    _$imageUiAtom.reportRead();
    return super.imageUi;
  }

  @override
  set imageUi(ui.Image? value) {
    _$imageUiAtom.reportWrite(value, super.imageUi, () {
      super.imageUi = value;
    });
  }

  final _$dataAtom = Atom(name: '_KycScreenStore.data');

  @override
  List<ml.Face>? get data {
    _$dataAtom.reportRead();
    return super.data;
  }

  @override
  set data(List<ml.Face>? value) {
    _$dataAtom.reportWrite(value, super.data, () {
      super.data = value;
    });
  }

  final _$selfieDataAtom = Atom(name: '_KycScreenStore.selfieData');

  @override
  SelfieData? get selfieData {
    _$selfieDataAtom.reportRead();
    return super.selfieData;
  }

  @override
  set selfieData(SelfieData? value) {
    _$selfieDataAtom.reportWrite(value, super.selfieData, () {
      super.selfieData = value;
    });
  }

  final _$selfieTypeAtom = Atom(name: '_KycScreenStore.selfieType');

  @override
  SelfieType get selfieType {
    _$selfieTypeAtom.reportRead();
    return super.selfieType;
  }

  @override
  set selfieType(SelfieType value) {
    _$selfieTypeAtom.reportWrite(value, super.selfieType, () {
      super.selfieType = value;
    });
  }

  final _$kycLivenessStateAtom = Atom(name: '_KycScreenStore.kycLivenessState');

  @override
  KycLivenessState get kycLivenessState {
    _$kycLivenessStateAtom.reportRead();
    return super.kycLivenessState;
  }

  @override
  set kycLivenessState(KycLivenessState value) {
    _$kycLivenessStateAtom.reportWrite(value, super.kycLivenessState, () {
      super.kycLivenessState = value;
    });
  }

  final _$detectFacesAsyncAction = AsyncAction('_KycScreenStore.detectFaces');

  @override
  Future<void> detectFaces(ml.InputImage imageValue, CameraImage cameraImage) {
    return _$detectFacesAsyncAction
        .run(() => super.detectFaces(imageValue, cameraImage));
  }

  @override
  String toString() {
    return '''
imageJpg: ${imageJpg},
imageUi: ${imageUi},
data: ${data},
selfieData: ${selfieData},
selfieType: ${selfieType},
kycLivenessState: ${kycLivenessState}
    ''';
  }
}
