import 'dart:io';

class PetRequest {
  final String name;
  final File image;
  final String status;
  final int speciesId;
  final int sizeCategoryId;

  PetRequest(
    this.image,
    this.status, {
    required this.name,
    required this.speciesId,
    required this.sizeCategoryId,
  });
}
