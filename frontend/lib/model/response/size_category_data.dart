import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/model/size_category.dart';

part 'size_category_data.freezed.dart';

part 'size_category_data.g.dart';

@freezed
class SizeCategoryData with _$SizeCategoryData {
  const factory SizeCategoryData({
    required List<SizeCategory> data,
  }) = _SizeCategoryData;

  factory SizeCategoryData.fromJson(Map<String, dynamic> json) =>
      _$SizeCategoryDataFromJson(json);
}
