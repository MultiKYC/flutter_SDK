// ignore_for_file: implementation_imports

import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/domain/usecases/base/get_use_case.dart';
import 'package:multi_kyc_sdk/src/general/log_helper.dart';
import 'package:native_exif/native_exif.dart';
import 'package:path_provider/path_provider.dart';

@LazySingleton()
@internal
class PrepareJpgData extends GetUseCase1<Uint8List?, Image> with LogHelper {
  static const tag = 'PrepareExifData';

  // Resource: https://exiv2.org/tags.html

  // The date and time of image creation. In Exif standard, it is the date and time the file was changed.
  // Exif.Image.DateTime
  static const _dateTimeKey = 'DateTime';

  // Exif.Image.XResolution
  static const _xResolutionKey = 'XResolution';

  // Exif.Image.YResolution
  static const _yResolutionKey = 'YResolution';

  // Exif.Image.Software
  static const _softwareKey = 'Software';

  static final _dateFormat = DateFormat('yyyy:MM:dd HH:MM:SS');

  PrepareJpgData();

  @override
  Future<Uint8List?> executeAsync(Image image) async {
    try {
      // convert image to jpg
      final List<int> jpg = encodeJpg(image);

      // prepare EXIF data
      final directory = await getApplicationDocumentsDirectory();
      final file2 = File('${directory.path}/image_jpg.jpg');
      await file2.writeAsBytes(jpg);
      final exif = await Exif.fromPath(file2.path);
      await exif.writeAttribute(_xResolutionKey, '${image.width}');
      await exif.writeAttribute(_yResolutionKey, '${image.height}');
      await exif.writeAttribute(_softwareKey, 'MultiKycMobile');
      await exif.writeAttribute(_dateTimeKey, _dateFormat.format(DateTime.now()));
      await exif.close();

      // return jpg with EXIF as bytes
      return file2.readAsBytes();
    } catch (e) {
      tLog.e(tag, e);
      return null;
    }
  }
}
