import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/model/size_category.dart';
import 'package:frontend/repository/category_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_provider.g.dart';

@riverpod
Future<List<Lookup>> vetSpecialties(
    Ref ref, ICategoryRepository categoryRepo) async {
  final res = await categoryRepo.getVetSpecialties();

  switch (res) {
    case Ok():
      return res.value!.data;
    case Error():
      return Future.error(res.error);
  }
}

@riverpod
Future<List<Lookup>> species(Ref ref, ICategoryRepository categoryRepo) async {
  final res = await categoryRepo.getSpecies();

  switch (res) {
    case Ok():
      return res.value!.data;
    case Error():
      return Future.error(res.error);
  }
}

@riverpod
Future<List<SizeCategory>> sizeCategories(
    Ref ref, ICategoryRepository categoryRepo) async {
  final res = await categoryRepo.getSizeCategories();

  switch (res) {
    case Ok():
      return res.value!.data;
    case Error():
      return Future.error(res.error);
  }
}
