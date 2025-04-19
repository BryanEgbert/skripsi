import 'package:frontend/model/size_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet_category.freezed.dart';

part 'pet_category.g.dart';

@freezed
class PetCategory with _$PetCategory {
  factory PetCategory({
    required int id,
    required String name,
    required SizeCategory sizeCategory,
    required int slotAmount,
  }) = _PetCategory;

  factory PetCategory.fromJson(Map<String, dynamic> json) =>
      _$PetCategoryFromJson(json);
}
