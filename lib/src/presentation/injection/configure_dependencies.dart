import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:multi_kyc_sdk/src/presentation/injection/configure_dependencies.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
@internal
Future<void> configureDependencies(String env) async {
  $initGetIt(getIt, environment: env);
  return Future.value();
}
