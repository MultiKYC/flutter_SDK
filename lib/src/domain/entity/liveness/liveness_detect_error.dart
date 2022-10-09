class LivenessDetectError {
  final bool centerNotDetected;
  final bool headTilted;
  final bool headFar;
  final bool headClose;

  LivenessDetectError({
    required this.centerNotDetected,
    required this.headTilted,
    required this.headFar,
    required this.headClose,
  });
}
