import 'dart:typed_data';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart' as ml;
import 'package:image/image.dart';
import 'package:injectable/injectable.dart';
import 'package:learning_input_image/learning_input_image.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/domain/repository/helper/image_helper.dart';
import 'package:multi_kyc_sdk/src/domain/usecases/prepare_jpg_data.dart';
import 'package:multi_kyc_sdk/src/presentation/injection/configure_dependencies.dart';

@LazySingleton(as: ImageHelper)
@internal
class ImageHelperImpl implements ImageHelper {
  final _prepareExifData = getIt<PrepareJpgData>();

  @override
  Future<Uint8List?> convertNv21ToJpg(CameraImage cameraImage, ml.InputImageRotation rotation) async {
    final imageWidth = cameraImage.width;
    final imageHeight = cameraImage.height;

    final yBuffer = cameraImage.planes[0].bytes;
    final uBuffer = cameraImage.planes[1].bytes;
    final vBuffer = cameraImage.planes[2].bytes;

    final int yRowStride = cameraImage.planes[0].bytesPerRow;
    final int yPixelStride = cameraImage.planes[0].bytesPerPixel!;

    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = Image(imageWidth, imageHeight);

    for (int h = 0; h < imageHeight; h++) {
      final int uvh = (h / 2).floor();

      for (int w = 0; w < imageWidth; w++) {
        final int uvw = (w / 2).floor();
        final yIndex = (h * yRowStride) + (w * yPixelStride);

        // Y plane should have positive values belonging to [0...255]
        final int y = yBuffer[yIndex];

        // U/V Values are subsampled i.e. each pixel in U/V chanel in a
        // YUV_420 image act as chroma value for 4 neighbouring pixels
        final int uvIndex = (uvh * uvRowStride) + (uvw * uvPixelStride);

        // U/V values ideally fall under [-0.5, 0.5] range. To fit them into
        // [0, 255] range they are scaled up and centered to 128.
        // Operation below brings U/V values to [-128, 127].
        final int u = uBuffer[uvIndex];
        final int v = vBuffer[uvIndex];

        // Compute RGB values per formula above.
        int r = (y + v * 1436 / 1024 - 179).round();
        int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
        int b = (y + u * 1814 / 1024 - 227).round();

        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        // Use 255 for alpha value, no transparency. ARGB values are
        // positioned in each byte of a single 4 byte integer
        // [AAAAAAAARRRRRRRRGGGGGGGGBBBBBBBB]
        final int argbIndex = h * imageWidth + w;

        image.data[argbIndex] = 0xff000000 | ((b << 16) & 0xff0000) | ((g << 8) & 0xff00) | (r & 0xff);
      }
    }

    final Image rotatedImage;

    switch (rotation) {
      case ml.InputImageRotation.rotation90deg:
        rotatedImage = copyRotate(image, 90);
        break;
      case ml.InputImageRotation.rotation180deg:
        rotatedImage = copyRotate(image, 180);
        break;
      case ml.InputImageRotation.rotation270deg:
        rotatedImage = copyRotate(image, 270);
        break;
      case ml.InputImageRotation.rotation0deg:
      default:
        rotatedImage = image;
        break;
    }

    return _prepareExifData.executeAsync(rotatedImage);
  }
}
