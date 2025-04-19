import 'package:freezed_annotation/freezed_annotation.dart';

part 'size_category.freezed.dart';

part 'size_category.g.dart';

@freezed
class SizeCategory with _$SizeCategory {
  const factory SizeCategory({
    required int id,
    required String name,
    required double minWeight,
    required double? maxWeight,
  }) = _SizeCategory;

  factory SizeCategory.fromJson(Map<String, dynamic> json) =>
      _$SizeCategoryFromJson(json);
}
