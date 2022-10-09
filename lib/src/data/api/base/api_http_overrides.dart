import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

@internal
class ApiHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => false;
  }
}
