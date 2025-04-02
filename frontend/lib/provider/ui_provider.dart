import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ui_provider.g.dart';

@riverpod
String locality(Ref ref) => "";

@riverpod
double latitude(Ref ref) => 0.0;

@riverpod
double longitude(Ref ref) => 0.0;
