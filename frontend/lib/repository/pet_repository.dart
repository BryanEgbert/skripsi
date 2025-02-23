import 'package:frontend/model/pet.dart';
import 'package:frontend/model/pet_request.dart';

abstract interface class IPetRepository {
  Future<Pet> getById(String token, String id);
  Future<List<Pet>> getPets(String token, int lastId, int size);
  Future<void> createPet(String token, PetRequest reqBody);
  Future<void> updatePet(String token, PetRequest reqBody);
  Future<void> deletePet(String token, int id);
}
