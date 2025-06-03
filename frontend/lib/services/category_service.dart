import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/model/pet_category.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/size_category.dart';

abstract interface class ICategoryService {
  Future<Result<ListData<Lookup>>> getVetSpecialties();
  Future<Result<ListData<Lookup>>> getDailyWalks();
  Future<Result<ListData<Lookup>>> getDailyPlaytime();
  Future<Result<ListData<Lookup>>> getPricingTypes();
  Future<Result<ListData<PetCategory>>> getPetCategories();
  Future<Result<ListData<SizeCategory>>> getSizeCategories();
}

class CategoryService implements ICategoryService {
  @override
  Future<Result<ListData<Lookup>>> getVetSpecialties() async {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      var res = await dio.get("http://$host/vet-specialties");

      return res;
    }, (res) => ListData.fromJson(res, Lookup.fromJson));
  }

  @override
  Future<Result<ListData<SizeCategory>>> getSizeCategories() async {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      var res = await dio.get("http://$host/size-categories");

      return res;
    }, (res) => ListData<SizeCategory>.fromJson(res, SizeCategory.fromJson));
  }

  @override
  Future<Result<ListData<PetCategory>>> getPetCategories() async {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");
      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      var res = await dio.get("http://$host/pet-categories");

      return res;
    }, (res) => ListData.fromJson(res, PetCategory.fromJson));
  }

  @override
  Future<Result<ListData<Lookup>>> getDailyPlaytime() {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      var res = await dio.get("http://$host/daily-playtimes");

      return res;
    }, (res) => ListData.fromJson(res, Lookup.fromJson));
  }

  @override
  Future<Result<ListData<Lookup>>> getDailyWalks() {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      var res = await dio.get("http://$host/daily-walks");

      return res;
    }, (res) => ListData.fromJson(res, Lookup.fromJson));
  }

  @override
  Future<Result<ListData<Lookup>>> getPricingTypes() {
    return makeRequest(200, () async {
      final String host =
          FirebaseRemoteConfig.instance.getString("backend_host");

      final dio = Dio(BaseOptions(
        validateStatus: (status) {
          return status != null; // Accept all HTTP status codes
        },
      ));

      var res = await dio.get("http://$host/pricing-types");

      return res;
    }, (res) => ListData.fromJson(res, Lookup.fromJson));
  }
}
