import 'dart:io' as native;

import 'package:injectable/injectable.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

@Singleton()
@internal
class Platform {
  bool get isAndroid => native.Platform.isAndroid;

  bool get isIOS => native.Platform.isIOS;
}
