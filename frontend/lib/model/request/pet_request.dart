import 'dart:io';

class PetRequest {
  final String name;
  final bool neutered;
  final File? petImage;
  final int petCategoryId;

  PetRequest({
    required this.name,
    this.petImage,
    required this.petCategoryId,
    required this.neutered,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "petName": name,
      "neutered": neutered,
      "petCategoryId": petCategoryId.toString(),
    };

    return map;
  }

  @override
  String toString() {
    return "PetRequest(name: $name, petCategoryId: $petCategoryId, image: ${petImage?.path})";
  }
}
