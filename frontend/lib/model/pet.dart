import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/model/pet_category.dart';
import 'package:frontend/model/user.dart';

part 'pet.freezed.dart';
part 'pet.g.dart';

@freezed
class Pet with _$Pet {
  const factory Pet({
    required int id,
    required String name,
    required String imageUrl,
    required String status,
    required User owner,
    required PetCategory petCategory,
  }) = _Pet;

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);
}
