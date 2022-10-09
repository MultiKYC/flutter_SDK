// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/domain/repository/log/log.dart';
import 'package:multi_kyc_sdk/src/presentation/injection/configure_dependencies.dart';

@internal
mixin LogHelper {
  final Log tLog = getIt<Log>();
}
