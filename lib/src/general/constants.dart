// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

@internal
class Constants {
  static const int livenessBounceValue = 500;
  static const double countCenterEventsToStart = 3; // count detected center images for start process uploading the photo
  static const double centerMinFill = 18; // minimum area to be filled
  static const double centerMaxFill = 33; // minimum area to be filled
  static const double headTiltedThreshold = 20; // percent of nose area width
  static const double horizontalDeviationPercentageMin = 180; // need to detect for turning head left and right
  static const double verticalDeviationTopPercentageMin = 5; // need to detect for turning head top
  static const double verticalDeviationBottomPercentageMin = 5; // need to detect for turning head bottom

  static const livenessDebugMode = false;
}
