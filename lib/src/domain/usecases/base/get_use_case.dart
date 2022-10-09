// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

@internal
abstract class GetUseCaseSync<T> {
  T executeAsync();
}

@internal
abstract class GetUseCaseSync1<T, T1> {
  T executeAsync(T1 value);
}

@internal
abstract class GetUseCase<T> {
  Future<T> executeAsync();
}

@internal
abstract class GetUseCase1<T, T1> {
  Future<T> executeAsync(T1 value);
}

@internal
abstract class GetUseCase2<T, T1, T2> {
  Future<T> executeAsync(T1 value1, T2 value2);
}

@internal
abstract class GetUseCase2N<T, T1, T2> {
  Future<T> executeAsync(T1 value1, {T2 value2});
}

@internal
abstract class GetUseCase3<T, T1, T2, T3> {
  Future<T> executeAsync(T1 value1, T2 value2, T3 value3);
}

@internal
abstract class GetUseCase4<T, T1, T2, T3, T4> {
  Future<T> executeAsync(T1 value1, T2 value2, T3 value3, T4 value4);
}

@internal
abstract class GetUseCase5<T, T1, T2, T3, T4, T5> {
  Future<T> executeAsync(T1 value1, T2 value2, T3 value3, T4 value4, T5 value);
}

@internal
abstract class GetUseCase6<T, T1, T2, T3, T4, T5, T6> {
  Future<T> executeAsync(T1 value1, T2 value2, T3 value3, T4 value4, T5 value5, T6 value6);
}

@internal
abstract class GetUseCase7<T, T1, T2, T3, T4, T5, T6, T7> {
  Future<T> executeAsync(T1 value1, T2 value2, T3 value3, T4 value4, T5 value5, T6 value6, T7 value7);
}
