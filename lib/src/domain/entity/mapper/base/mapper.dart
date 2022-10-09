import 'dart:core';

// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

@internal
abstract class Mapper<T1, T2> {
  T2 map(T1 value);

  T1 reverseMap(T2 value);

  List<T2> mapList(List<T1> values) {
    final List<T2> returnValues = [];

    for (final T1 value in values) {
      returnValues.add(map(value));
    }

    return returnValues;
  }

  List<T1> reverseMapList(List<T2> values) {
    final List<T1> returnValues = [];

    for (final T2 value in values) {
      returnValues.add(reverseMap(value));
    }

    return returnValues;
  }
}
