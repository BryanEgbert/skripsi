import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/model/pet_category.dart';
import 'package:frontend/model/size_category.dart';
import 'package:frontend/services/category_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_provider.g.dart';

@riverpod
Future<List<Lookup>> vetSpecialties(Ref ref) async {
  CategoryService categoryService = CategoryService();
  final res = await categoryService.getVetSpecialties();

  switch (res) {
    case Ok():
      return res.value!.data;
    case Error():
      return Future.error(res.error);
  }
}

@riverpod
Future<List<Lookup>> dailyWalks(Ref ref) async {
  CategoryService categoryService = CategoryService();
  final res = await categoryService.getDailyWalks();

  switch (res) {
    case Ok():
      return res.value!.data;
    case Error():
      return Future.error(res.error);
  }
}

@riverpod
Future<List<Lookup>> dailyPlaytimes(Ref ref) async {
  CategoryService categoryService = CategoryService();
  final res = await categoryService.getDailyPlaytime();

  switch (res) {
    case Ok():
      return res.value!.data;
    case Error():
      return Future.error(res.error);
  }
}

@riverpod
Future<List<PetCategory>> petCategory(Ref ref) async {
  CategoryService categoryService = CategoryService();
  final res = await categoryService.getPetCategories();

  switch (res) {
    case Ok():
      return res.value!.data;
    case Error():
      return Future.error(res.error);
  }
}

@riverpod
Future<List<SizeCategory>> sizeCategories(Ref ref) async {
  CategoryService categoryService = CategoryService();
  final res = await categoryService.getSizeCategories();

  switch (res) {
    case Ok():
      return res.value!.data;
    case Error():
      return Future.error(res.error);
  }
}
