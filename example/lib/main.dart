import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kyc/general/constants.dart';
import 'package:kyc/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(Constants.orientations).whenComplete(() {
    runApp(
      MaterialApp(
        onGenerateTitle: (context) {
          return 'KYC';
        },
        home: SplashScreen(),
      ),
    );
  });
}
