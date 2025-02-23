import 'dart:io';

class PetRequest {
  final String name;
  final File image;
  final int speciesId;
  final int sizeCategoryId;

  PetRequest({
    required this.name,
    required this.speciesId,
    required this.sizeCategoryId,
    required this.image,
  });

  Map<String, String> toMap() {
    Map<String, String> map = {
      "name": name,
      "speciesId": speciesId.toString(),
      "sizeCategoryId": sizeCategoryId.toString(),
    };

    return map;
  }
}
