// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

@internal
abstract class SetUseCase<T> {
  Future<bool> executeAsync(T value);
}
