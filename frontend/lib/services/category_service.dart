import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/size_category.dart';
import 'package:http/http.dart' as http;

abstract interface class ICategoryService {
  Future<Result<ListData<Lookup>>> getVetSpecialties();
  Future<Result<ListData<Lookup>>> getSpecies();
  Future<Result<ListData<SizeCategory>>> getSizeCategories();
}

class CategoryService implements ICategoryService {
  @override
  Future<Result<ListData<Lookup>>> getVetSpecialties() async {
    return makeRequest(200, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      var res = await Dio().get("$host/vet-specialties");

      return res;
    }, (res) => ListData.fromJson(res, Lookup.fromJson));
  }

  @override
  Future<Result<ListData<SizeCategory>>> getSizeCategories() async {
    return makeRequest(200, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      var res = await Dio().get("$host/size-categoriess");

      return res;
    }, (res) => ListData<SizeCategory>.fromJson(res, SizeCategory.fromJson));
  }

  @override
  Future<Result<ListData<Lookup>>> getSpecies() async {
    return makeRequest(200, () async {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      var res = await Dio().get("$host/vet-specialties");

      return res;
    }, (res) => ListData.fromJson(res, Lookup.fromJson));
  }
}
