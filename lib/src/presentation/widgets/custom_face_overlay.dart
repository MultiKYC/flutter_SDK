import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/domain/entity/liveness/selfie_data.dart';
import 'package:multi_kyc_sdk/src/presentation/widgets/custom_face_painter.dart';

@internal
class CustomFaceOverlay extends StatelessWidget {
  final SelfieData data;
  final Size size;

  const CustomFaceOverlay({
    super.key,
    required this.data,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CustomFacePainter(data: data),
      child: SizedBox(
        width: size.width,
        height: size.height,
      ),
    );
  }
}
