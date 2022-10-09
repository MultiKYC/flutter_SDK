import 'package:flutter/material.dart';

class TestSdkErrorWidget extends StatelessWidget {
  const TestSdkErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'KYC ERROR',
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.w700,
        fontSize: 18.0,
        height: 24.0 / 18.0,
      ),
    );
  }
}
