import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:injectable/injectable.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/domain/entity/liveness/selfie_data.dart';
import 'package:multi_kyc_sdk/src/domain/repository/kyc/kyc_repository.dart';
import 'package:multi_kyc_sdk/src/domain/usecases/base/get_use_case.dart';
import 'package:multi_kyc_sdk/src/general/log_helper.dart';
import 'package:multi_kyc_sdk/src/presentation/injection/configure_dependencies.dart';

@LazySingleton()
@internal
class DetectSelfieData extends GetUseCase7<SelfieData?, Size, Rect, InputImage, List<Face>, bool, bool, SelfieData?> with LogHelper {
  static const tag = 'DetectSelfieData';

  final _kycRepository = getIt<KycRepository>();

  DetectSelfieData();

  @override
  Future<SelfieData?> executeAsync(
    Size size,
    Rect centerArea,
    InputImage image,
    List<Face> data,
    bool skipHorizontal,
    bool skipVertical,
    SelfieData? centerFaceData,
  ) async {
    SelfieData? result;

    try {
      if (data.length == 1) {
        final face = data[0];
        final rotation = image.inputImageData!.imageRotation;

        final imageRect = Offset.zero & size;
        final headRect = _getHeadRect(rotation, face, size, image.inputImageData!.size);
        final noseRect = _getNoseRect(rotation, face, size, image.inputImageData!.size);
        final List<Point> nosePoint = _getNosePoints(rotation, face, size, image.inputImageData!.size);
        Point? leftPoint;
        Point? rightPoint;

        if (nosePoint.length == 2) {
          leftPoint = nosePoint[0];
          rightPoint = nosePoint[1];
        }

        final Point eyePointLeft = _getLeftEyePoints(rotation, face, size, image.inputImageData!.size)!;
        final Point eyePointRight = _getRightEyePoints(rotation, face, size, image.inputImageData!.size)!;

        final detectData = await _kycRepository.detectSelfie(
          imageRect: imageRect,
          noseRect: noseRect,
          headRect: headRect,
          centerArea: centerArea,
          nosePointLeft: leftPoint,
          nosePointRight: rightPoint,
          eyePointLeft: eyePointLeft,
          eyePointRight: eyePointRight,
          skipHorizontal: skipHorizontal,
          skipVertical: skipVertical,
          centerFaceData: centerFaceData,
        );

        result = SelfieData(
          imageRect: imageRect,
          noseRect: noseRect,
          headRect: headRect,
          eyePointLeft: eyePointLeft,
          eyePointRight: eyePointRight,
          detectData: detectData,
          rotation: rotation,
        );

        tLog.d(tag, 'executeAsync, result: $result');
      }
    } catch (e) {
      tLog.e(tag, e);
    }

    return Future.value(result);
  }

  List<Point> _getNosePoints(InputImageRotation rotation, Face face, Size size, Size imageSize) {
    final List<Point> result = [];

    for (final item in face.contours.values) {
      if (item != null && item.type == FaceContourType.noseBottom) {
        result.add(item.points.reduce((current, next) => current.x < next.x ? current : next));
        result.add(item.points.reduce((current, next) => current.x > next.x ? current : next));
      }
    }

    return result;
  }

  Point<double>? _getLeftEyePoints(InputImageRotation rotation, Face face, Size size, Size imageSize) {
    for (final item in face.contours.values) {
      if (item != null && item.type == FaceContourType.leftEye) {
        final Point point = item.points.reduce((current, next) => current.x < next.x ? current : next);
        return Point<double>(
          _transformX(rotation, point.x.toDouble(), size, imageSize),
          _transformY(rotation, point.y.toDouble(), size, imageSize),
        );
      }
    }

    return null;
  }

  Point<double>? _getRightEyePoints(InputImageRotation rotation, Face face, Size size, Size imageSize) {
    for (final item in face.contours.values) {
      if (item != null && item.type == FaceContourType.rightEye) {
        final Point point = item.points.reduce((current, next) => current.x < next.x ? current : next);
        return Point<double>(
          _transformX(rotation, point.x.toDouble(), size, imageSize),
          _transformY(rotation, point.y.toDouble(), size, imageSize),
        );
      }
    }

    return null;
  }

  Rect _getHeadRect(InputImageRotation rotation, Face face, Size size, Size imageSize) {
    double left = size.width;
    double top = size.height;
    double right = 0;
    double bottom = 0;

    for (final item in face.contours.values) {
      if (item != null && item.type == FaceContourType.face) {
        for (final offset in item.points) {
          left = min(left, offset.x.toDouble());
          right = max(right, offset.x.toDouble());
          top = min(top, offset.y.toDouble());
          bottom = max(bottom, offset.y.toDouble());
        }
      }
    }

    final transformLeft = _transformX(rotation, left, size, imageSize);
    final transformTop = _transformY(rotation, top, size, imageSize);
    final transformRight = _transformX(rotation, right, size, imageSize);
    final transformBottom = _transformY(rotation, bottom, size, imageSize);

    return Rect.fromLTRB(
      min(transformLeft, transformRight),
      min(transformTop, transformBottom),
      max(transformLeft, transformRight),
      max(transformTop, transformBottom),
    );
  }

  Rect _getNoseRect(InputImageRotation rotation, Face face, Size size, Size imageSize) {
    double left = size.width;
    double top = size.height;
    double right = 0;
    double bottom = 0;

    for (final item in face.contours.values) {
      if (item != null && (item.type == FaceContourType.noseBridge || item.type == FaceContourType.noseBottom)) {
        for (final offset in item.points) {
          left = min(left, offset.x.toDouble());
          right = max(right, offset.x.toDouble());
          top = min(top, offset.y.toDouble());
          bottom = max(bottom, offset.y.toDouble());
        }
      }
    }

    final transformLeft = _transformX(rotation, left, size, imageSize);
    final transformTop = _transformY(rotation, top, size, imageSize);
    final transformRight = _transformX(rotation, right, size, imageSize);
    final transformBottom = _transformY(rotation, bottom, size, imageSize);

    return Rect.fromLTRB(
      min(transformLeft, transformRight),
      min(transformTop, transformBottom),
      max(transformLeft, transformRight),
      max(transformTop, transformBottom),
    );
  }

  double _transformX(rotation, double x, Size size, Size imageSize) {
    switch (rotation) {
      case InputImageRotation.rotation90deg:
        return x * size.width / imageSize.height;
      case InputImageRotation.rotation270deg:
        return size.width - x * size.width / imageSize.height;
      default:
        return x * size.width / imageSize.width;
    }
  }

  double _transformY(InputImageRotation rotation, double y, Size size, Size imageSize) {
    switch (rotation) {
      case InputImageRotation.rotation90deg:
      case InputImageRotation.rotation270deg:
        return y * size.height / imageSize.width;
      default:
        return y * size.height / imageSize.height;
    }
  }
}
