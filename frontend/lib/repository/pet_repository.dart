import 'package:frontend/model/pet.dart';
import 'package:frontend/model/request/pet_request.dart';

abstract interface class IPetRepository {
  Future<Pet> getById(String token, String id);
  Future<List<Pet>> getPets(String token, int lastId, int size);
  Future<void> createPet(String token, PetRequest reqBody);
  Future<void> updatePet(String token, PetRequest reqBody);
  Future<void> deletePet(String token, int id);
}

class PetRepository implements IPetRepository {
  @override
  Future<void> createPet(String token, PetRequest reqBody) {
    // TODO: implement createPet
    throw UnimplementedError();
  }

  @override
  Future<void> deletePet(String token, int id) {
    // TODO: implement deletePet
    throw UnimplementedError();
  }

  @override
  Future<Pet> getById(String token, String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<Pet>> getPets(String token, int lastId, int size) {
    // TODO: implement getPets
    throw UnimplementedError();
  }

  @override
  Future<void> updatePet(String token, PetRequest reqBody) {
    // TODO: implement updatePet
    throw UnimplementedError();
  }
}
