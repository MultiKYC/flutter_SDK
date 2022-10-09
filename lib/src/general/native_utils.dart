import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/presentation/injection/configure_dependencies.dart';

@internal
abstract class NativeUtils {
  bool isAndroidUI();

  void applyDefaultSystemStyles();

  double getContentWidth(BuildContext context);

  double getScreenWidth(BuildContext context);

  double getContentHeight(BuildContext context);

  double getStatusBarHeight(BuildContext context);

  double getScaleFactor();

  DeviceSizeType getDeviceSizeType();

  bool isTablet(MediaQueryData data);

  String getDefaultLocale();

  bool isKeyboardIsVisible(BuildContext context);
}

@Singleton(as: NativeUtils)
class NativeUtilsImpl implements NativeUtils {
  static const tag = 'NativeUtilsImpl';

  static NativeUtils get instance {
    return getIt<NativeUtils>();
  }

  @override
  bool isAndroidUI() {
    return Platform.isAndroid;
  }

  @override
  void applyDefaultSystemStyles() {
    try {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      );
    } catch (e) {
      debugPrint('ERROR : $tag : $e');
    }
  }

  @override
  double getContentWidth(BuildContext context) {
    double result = 0;

    try {
      result = MediaQuery.of(context).size.width;
      result -= MediaQuery.of(context).padding.left;
      result -= MediaQuery.of(context).padding.right;
    } catch (e) {
      debugPrint('ERROR : $tag : $e');
    }

    return result;
  }

  @override
  double getScreenWidth(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  double getContentHeight(BuildContext context) {
    double result = 0;

    try {
      result = MediaQuery.of(context).size.height;
      result -= const Size.fromHeight(kToolbarHeight).height * 1.45;
      result -= MediaQuery.of(context).padding.top;
      result -= MediaQuery.of(context).padding.bottom;
    } catch (e) {
      debugPrint('ERROR : $tag : $e');
    }

    return result;
  }

  @override
  double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  @override
  double getScaleFactor() {
    double result = 1;

    switch (getDeviceSizeType()) {
      case DeviceSizeType.normal:
        result = 1;
        break;
      case DeviceSizeType.small:
        result = 0.8;
        break;
      case DeviceSizeType.large:
        result = 1.4;
        break;
    }

    return result;
  }

  @override
  DeviceSizeType getDeviceSizeType() {
    DeviceSizeType result = DeviceSizeType.normal;
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

    if (isTablet(data)) {
      result = DeviceSizeType.large;
    } else {
      final size = data.size.shortestSide * data.devicePixelRatio;

      if (size < 750) {
        result = DeviceSizeType.small;
      } else {
        result = DeviceSizeType.normal;
      }
    }

    return result;
  }

  @override
  bool isTablet(MediaQueryData data) {
    bool result = false;
    final devicePixelRatio = data.devicePixelRatio;

    if (devicePixelRatio < 2 && (data.size.width * devicePixelRatio >= 1000 || data.size.height * devicePixelRatio >= 1000)) {
      result = true;
    } else if (devicePixelRatio == 2 && (data.size.width * devicePixelRatio >= 1920 || data.size.height * devicePixelRatio >= 1920)) {
      result = true;
    }

    return result;
  }

  @override
  String getDefaultLocale() {
    return Platform.localeName.split('_')[0];
  }

  @override
  bool isKeyboardIsVisible(BuildContext context) {
    if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

enum DeviceSizeType { small, normal, large }
