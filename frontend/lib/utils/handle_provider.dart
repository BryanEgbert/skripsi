import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/error_text.dart';

Widget? handleProvider<T>(AsyncValue<T> provValue, dynamic Function() onRefresh,
    Widget Function(T value) widget) {
  switch (provValue) {
    case AsyncError(:final error):
      return ErrorText(
        errorText: error.toString(),
        onRefresh: onRefresh,
      );
    case AsyncData(:final value):
      return widget(value);
    default:
      return Center(
        child: CircularProgressIndicator(color: Colors.orange),
      );
  }
}
