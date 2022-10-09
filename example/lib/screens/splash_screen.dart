import 'package:flutter/material.dart';
import 'package:kyc/screens/config_screen.dart';

class SplashScreen extends StatefulWidget {
  static const tag = 'SplashScreen';

  @override
  _SplashScreenState createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2)).whenComplete(() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => ConfigScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF00C777),
      body: Center(
        child: Text(
          'KYC',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 40.0,
            height: 48.0 / 40.0,
          ),
        ),
      ),
    );
  }
}
