import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:multi_kyc_sdk/multi_kyc_sdk.dart';

class TestLivenessOverlayWidget extends StatelessWidget {
  final KycLivenessState state;
  final LivenessDetectError? error;
  final Size? fullAreaSize;
  final Rect? centerArea;

  const TestLivenessOverlayWidget({
    super.key,
    required this.state,
    required this.error,
    required this.fullAreaSize,
    required this.centerArea,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (centerArea != null) ...[
          Center(
            child: SizedBox(
              width: centerArea!.width,
              height: centerArea!.height,
              child: _FaceBorderWidget(
                width: centerArea!.width,
                height: centerArea!.height,
                state: state,
              ),
            ),
          ),
        ],
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 16,
              ),
              child: Text(
                _getErrorText() ?? _getNextHintText(),
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w700,
                  fontSize: 24.0,
                  height: 28.0 / 24.0,
                  letterSpacing: 0.01,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String? _getErrorText() {
    if (error != null) {
      if (error!.headTilted) {
        return 'Keep your head straight';
      }

      if (error!.headFar) {
        return 'The screen is too far from the face';
      }

      if (error!.headClose) {
        return 'The screen is too close to the face';
      }

      if (error!.centerNotDetected) {
        return 'Put a frame on the face';
      }
    }

    return null;
  }

  String _getNextHintText() {
    if (state.selfCenter != KycLivenessStatus.success) {
      return 'Put a frame on the face';
    }

    if (state.selfLeft != KycLivenessStatus.success) {
      return 'Turn your head to the left';
    }

    if (state.selfRight != KycLivenessStatus.success) {
      return 'Turn your head to the right';
    }

    if (state.selfTop != KycLivenessStatus.success) {
      return 'Lift your head up';
    }

    if (state.selfBottom != KycLivenessStatus.success) {
      return 'Put your head down';
    }

    return '';
  }
}

class _FaceBorderWidget extends LeafRenderObjectWidget {
  final double width;
  final double height;
  final KycLivenessState state;

  const _FaceBorderWidget({
    required this.width,
    required this.height,
    required this.state,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _FaceBorderRenderObject(
      width: width,
      height: height,
      state: state,
    );
  }
}

class _FaceBorderRenderObject extends RenderBox {
  final double width;
  final double height;
  final KycLivenessState state;

  _FaceBorderRenderObject({
    required this.width,
    required this.height,
    required this.state,
  });

  @override
  void paint(PaintingContext context, Offset offset) {
    final rect = Rect.fromLTRB(offset.dx, offset.dy, width + offset.dx, height + offset.dy);

    if (state.selfCenter == KycLivenessStatus.success) {
      const oneDegree = math.pi / 180;
      const offset = oneDegree * 2;

      final paintTop = Paint()
        ..color = _getColorFromStatus(state.selfTop)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = _getBorderWidth(state.selfTop);

      final paintBottom = Paint()
        ..color = _getColorFromStatus(state.selfBottom)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = _getBorderWidth(state.selfBottom);

      final paintLeft = Paint()
        ..color = _getColorFromStatus(state.selfLeft)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = _getBorderWidth(state.selfLeft);

      final paintRight = Paint()
        ..color = _getColorFromStatus(state.selfRight)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = _getBorderWidth(state.selfRight);

      context.canvas.drawArc(rect, -math.pi + oneDegree * 45 + offset, math.pi - 2 * oneDegree * 45 - 2 * offset, false, paintTop);
      context.canvas.drawArc(rect, oneDegree * 45 + offset, math.pi - 2 * oneDegree * 45 - 2 * offset, false, paintBottom);
      context.canvas.drawArc(rect, math.pi - oneDegree * 45 + offset, math.pi - 2 * oneDegree * 45 - 2 * offset, false, paintLeft);
      context.canvas.drawArc(rect, -oneDegree * 45 + offset, math.pi - 2 * oneDegree * 45 - 2 * offset, false, paintRight);
    } else {
      final paint = Paint()
        ..color = _getColorFromStatus(state.selfCenter)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = _getBorderWidth(state.selfCenter);
      context.canvas.drawArc(rect, 0, 2 * math.pi, false, paint);
    }

    super.paint(context, offset);
  }

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    size = constraints.biggest;
    super.performResize();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return Size(width, height);
  }

  double _getBorderWidth(KycLivenessStatus status) {
    switch (status) {
      case KycLivenessStatus.none:
        return 3;
      case KycLivenessStatus.progress:
        return 8;
      case KycLivenessStatus.success:
        return 8;
      case KycLivenessStatus.error:
        return 8;
    }
  }

  Color _getColorFromStatus(KycLivenessStatus status) {
    switch (status) {
      case KycLivenessStatus.none:
        return Colors.white;
      case KycLivenessStatus.progress:
        return Colors.white;
      case KycLivenessStatus.success:
        return const Color(0xFF00C777);
      case KycLivenessStatus.error:
        return const Color(0xFF790914);
    }
  }
}
