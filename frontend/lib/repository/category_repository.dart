import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/model/response/error_response.dart';
import 'package:frontend/model/response/lookup_data.dart';
import 'package:frontend/model/response/size_category_data.dart';
import 'package:frontend/model/size_category.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/model/lookup.dart';

abstract interface class ICategoryRepository {
  Future<List<Lookup>> getVetSpecialties();
  Future<List<Lookup>> getSpecies();
  Future<List<SizeCategory>> getSizeCategories();
}

class CategoryRepository implements ICategoryRepository {
  @override
  Future<List<Lookup>> getVetSpecialties() async {
    try {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      var res = await http.get(Uri.parse("$host/vet-specialties"));

      if (res.statusCode == 200) {
        return LookupData.fromJson(jsonDecode(res.body) as Map<String, dynamic>)
            .data;
      } else {
        ErrorResponse errorRes = ErrorResponse.fromJson(
            jsonDecode(res.body) as Map<String, dynamic>);
        throw Exception(errorRes.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SizeCategory>> getSizeCategories() async {
    try {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      var res = await http.get(Uri.parse("$host/size-categor"));

      if (res.statusCode == 200) {
        return SizeCategoryData.fromJson(
                jsonDecode(res.body) as Map<String, dynamic>)
            .data;
      } else {
        ErrorResponse errorRes = ErrorResponse.fromJson(
            jsonDecode(res.body) as Map<String, dynamic>);
        throw Exception(errorRes.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Lookup>> getSpecies() async {
    try {
      await dotenv.load();
      final String host = dotenv.env["HOST"]!;

      var res = await http.get(Uri.parse("$host/vet-specialties"));

      if (res.statusCode == 200) {
        return LookupData.fromJson(jsonDecode(res.body) as Map<String, dynamic>)
            .data;
      } else {
        ErrorResponse errorRes = ErrorResponse.fromJson(
            jsonDecode(res.body) as Map<String, dynamic>);
        throw Exception(errorRes.message);
      }
    } catch (e) {
      rethrow;
    }
  }
}
