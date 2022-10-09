import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:injectable/injectable.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/domain/entity/liveness/liveness_detect_data.dart';
import 'package:multi_kyc_sdk/src/domain/entity/liveness/liveness_detect_error.dart';
import 'package:multi_kyc_sdk/src/domain/entity/liveness/selfie_data.dart';
import 'package:multi_kyc_sdk/src/domain/entity/liveness/selfie_type.dart';
import 'package:multi_kyc_sdk/src/domain/repository/kyc/kyc_repository.dart';
import 'package:multi_kyc_sdk/src/general/constants.dart';
import 'package:multi_kyc_sdk/src/general/log_helper.dart';

@LazySingleton(as: KycRepository)
@internal
class KycRepositoryImpl with LogHelper implements KycRepository {
  static const tag = 'KycRepositoryImpl';

  @override
  Future<LivenessDetectData> detectSelfie({
    required Rect imageRect,
    required Rect headRect,
    required Rect noseRect,
    required Rect centerArea,
    required Point? nosePointLeft,
    required Point? nosePointRight,
    required Point? eyePointLeft,
    required Point? eyePointRight,
    bool skipHorizontal = true,
    bool skipVertical = true,
    SelfieData? centerFaceData,
  }) async {
    SelfieType selfieType = SelfieType.none;

    final headTilted = _isHeadTilted(nosePointLeft, nosePointRight, noseRect);
    final double topHeadPadding = headRect.top * 100 / imageRect.height;
    final double bottomHeadPadding = (imageRect.bottom - headRect.bottom) * 100 / imageRect.height;
    final double leftHeadPadding = headRect.left * 100 / imageRect.width;
    final double rightHeadPadding = (imageRect.right - headRect.right) * 100 / imageRect.width;

    double rightDeviationPercentage = 0;
    double leftDeviationPercentage = 0;
    double topDeviationPercentage = 0;
    double bottomDeviationPercentage = 0;

    bool isCenterDetected = false;
    final fillCenterHead = _calculateFillCenterHead(imageRect, headRect, centerArea);
    final bool headFar = fillCenterHead < Constants.centerMinFill;
    final bool headClose = fillCenterHead > Constants.centerMaxFill;

    if (!headTilted) {
      // final noseTopPositionDiff = (noseRect.top - headRect.top).abs() * 100 / headRect.height;
      // final noseBottomPositionDiff = (headRect.bottom - noseRect.bottom).abs() * 100 / headRect.height;
      // final noseLeftPositionDiff = (noseRect.left - headRect.left).abs() * 100 / headRect.width;
      // final noseRightPositionDiff = (headRect.right - noseRect.right).abs() * 100 / headRect.width;
      //
      // tLog.d(tag, 'noseTopPositionDiff: ${noseTopPositionDiff ~/ 1}');
      // tLog.d(tag, 'noseBottomPositionDiff: ${noseBottomPositionDiff ~/ 1}');
      // tLog.d(tag, 'noseLeftPositionDiff: ${noseLeftPositionDiff ~/ 1}');
      // tLog.d(tag, 'noseRightPositionDiff: ${noseRightPositionDiff ~/ 1}');

      // detecting if the face on the center
      if (fillCenterHead > Constants.centerMinFill && fillCenterHead < Constants.centerMaxFill) {
        selfieType = SelfieType.center;
        isCenterDetected = true;
      }

      // detect left/right turning head
      if (!skipHorizontal && selfieType == SelfieType.center) {
        final leftDistanceFaceNose = (noseRect.left - headRect.left).abs();
        final rightDistanceFaceNose = (headRect.right - noseRect.right).abs();

        if (leftDistanceFaceNose < rightDistanceFaceNose) {
          leftDeviationPercentage = (rightDistanceFaceNose * 100) / leftDistanceFaceNose;

          if (leftDeviationPercentage > Constants.horizontalDeviationPercentageMin) {
            selfieType = SelfieType.left;
          }
        }

        if (leftDistanceFaceNose > rightDistanceFaceNose) {
          rightDeviationPercentage = (leftDistanceFaceNose * 100) / rightDistanceFaceNose;

          if (rightDeviationPercentage > Constants.horizontalDeviationPercentageMin) {
            selfieType = SelfieType.right;
          }
        }
      }

      // detect top/bottom turning head
      if (!skipVertical && centerFaceData != null && eyePointLeft != null && eyePointRight != null) {
        final centerDeviation = centerFaceData.noseRect.top - (centerFaceData.eyePointLeft.y + centerFaceData.eyePointRight.y) / 2;
        final deviation = noseRect.top - (eyePointLeft.y + eyePointRight.y) / 2;
        topDeviationPercentage = (deviation.abs() - centerDeviation.abs()) * 100 / noseRect.height;
        bottomDeviationPercentage = (centerDeviation.abs() - deviation.abs()) * 100 / noseRect.height;

        if (topDeviationPercentage > 0 && topDeviationPercentage > Constants.verticalDeviationTopPercentageMin) {
          selfieType = SelfieType.top;
        }

        if (bottomDeviationPercentage > 0 && bottomDeviationPercentage > Constants.verticalDeviationBottomPercentageMin) {
          selfieType = SelfieType.bottom;
        }
      }
    }

    return Future.value(
      LivenessDetectData(
        selfieType: selfieType,
        topHeadPadding: topHeadPadding,
        bottomHeadPadding: bottomHeadPadding,
        leftHeadPadding: leftHeadPadding,
        rightHeadPadding: rightHeadPadding,
        fillCenterHead: fillCenterHead,
        rightDeviationPercentage: rightDeviationPercentage,
        leftDeviationPercentage: leftDeviationPercentage,
        topDeviationPercentage: topDeviationPercentage,
        bottomDeviationPercentage: bottomDeviationPercentage,
        detectError: LivenessDetectError(
          centerNotDetected: !isCenterDetected,
          headTilted: headTilted,
          headFar: headFar,
          headClose: headClose,
        ),
      ),
    );
  }

  bool _isHeadTilted(Point? leftPoint, Point? rightPoint, Rect noseRect) {
    bool result = false;

    if (leftPoint != null && rightPoint != null && leftPoint != rightPoint) {
      final noseWidth = noseRect.width.abs();
      final noseDiff = (leftPoint.y - rightPoint.y).abs();
      final changes = noseDiff * 100 / noseWidth;
      result = changes > Constants.headTiltedThreshold;
    }

    return result;
  }

  double _calculateFillCenterHead(Rect imageRect, Rect headRect, Rect centerArea) {
    final double full = imageRect.width * imageRect.height;
    double sum = 0;

    for (int y = 0; y < imageRect.height; y++) {
      for (int x = 0; x < imageRect.width; x++) {
        if (headRect.contains(Offset(x.toDouble(), y.toDouble())) && centerArea.contains(Offset(x.toDouble(), y.toDouble()))) {
          sum += 1;
        }
      }
    }

    return (sum / full) * 100;
  }
}
