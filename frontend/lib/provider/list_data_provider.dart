import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/booking_request.dart';
import 'package:frontend/model/coordinate.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/pet.dart';
import 'package:frontend/model/pet_daycare.dart';
import 'package:frontend/model/request/pet_daycare_filters.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/model/reviews.dart';
import 'package:frontend/model/transaction.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/model/vaccine_record.dart';
import 'package:frontend/services/pet_daycare_service.dart';
import 'package:frontend/services/pet_service.dart';
import 'package:frontend/services/transaction_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/services/vaccination_record_service.dart';
import 'package:frontend/utils/refresh_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'list_data_provider.g.dart';

@riverpod
Future<ListData<PetDaycare>> petDaycares(Ref ref, double? lat, double? long,
    [int lastId = 0, int pageSize = 10]) async {
  TokenResponse token = await refreshToken();

  final petDaycareService = PetDaycareService();

  final daycares = await petDaycareService.getPetDaycares(
    token.accessToken,
    Coordinate(latitude: lat, longitude: long),
    PetDaycareFilters(),
    CursorBasedPaginationQueryParams(lastId: lastId, pageSize: pageSize),
  );

  switch (daycares) {
    case Ok():
      return daycares.value!;
    case Error():
      return Future.error(daycares.error);
  }
}

@riverpod
Future<Pet> pet(Ref ref, int petId) async {
  TokenResponse token = await refreshToken();

  final petService = PetService();
  final res = await petService.getById(token.accessToken, petId);

  switch (res) {
    case Ok():
      return res.value!;
    case Error():
      return Future.error(res.error);
  }
}

@riverpod
Future<ListData<VaccineRecord>> vaccineRecords(Ref ref, int petId,
    [int lastId = 0, int pageSize = 10]) async {
  TokenResponse token = await refreshToken();

  final petService = PetService();
  final res = await petService.getVaccineRecords(token.accessToken, petId,
      CursorBasedPaginationQueryParams(lastId: lastId, pageSize: pageSize));

  switch (res) {
    case Ok():
      return res.value!;
    case Error():
      return Future.error(res.error);
  }
}

@riverpod
Future<VaccineRecord> getVaccinationRecordById(
    Ref ref, int vaccinationRecordId) async {
  TokenResponse token = await refreshToken();

  final service = VaccinationRecordService();
  final res = await service.getById(token.accessToken, vaccinationRecordId);

  switch (res) {
    case Ok():
      return res.value!;
    case Error():
      return Future.error(res.error);
  }
}

@riverpod
Future<ListData<Pet>> petList(Ref ref,
    [int lastId = 0, int pageSize = 10]) async {
  TokenResponse? token;
  try {
    token = await refreshToken();
  } catch (e) {
    return Future.error(e.toString());
  }

  final petService = PetService();

  final res = await petService.getPets(
      token!.accessToken, CursorBasedPaginationQueryParams());

  switch (res) {
    case Ok():
      return res.value!;
    case Error():
      return Future.error(res.error);
  }
}

@riverpod
Future<ListData<Pet>> bookedPets(Ref ref,
    [int lastId = 0, int pageSize = 10]) async {
  TokenResponse? token;
  try {
    token = await refreshToken();
  } catch (e) {
    return Future.error(e.toString());
  }

  final petService = PetService();

  final res = await petService.getBookedPets(token.accessToken,
      CursorBasedPaginationQueryParams(lastId: lastId, pageSize: pageSize));

  switch (res) {
    case Ok():
      return res.value!;
    case Error():
      return Future.error(res.error);
  }
}

@riverpod
Future<Pet?> getPetById(Ref ref, int petId) async {
  TokenResponse? token;
  try {
    token = await refreshToken();
  } catch (e) {
    return Future.error(e.toString());
  }

  final petService = PetService();
  final res = await petService.getById(token.accessToken, petId);

  switch (res) {
    case Ok():
      return res.value!;
    case Error():
      return Future.error(res.error);
  }
}

@riverpod
Future<User> getUserById(Ref ref, int userId) async {
  TokenResponse? token;
  try {
    token = await refreshToken();
  } catch (e) {
    return Future.error(e.toString());
  }

  final userService = UserService();
  final res = await userService.getUser(token.accessToken, userId);

  switch (res) {
    case Ok():
      return res.value!;
    case Error():
      return Future.error(res.error);
  }
}

@riverpod
Future<ListData<User>> getVets(Ref ref,
    [int lastId = 0, int pageSize = 10, int vetSpecialtyId = 0]) async {
  TokenResponse? token;
  try {
    token = await refreshToken();
  } catch (e) {
    return Future.error(e.toString());
  }

  final userService = UserService();
  final res = await userService.getVets(
    token.accessToken,
    CursorBasedPaginationQueryParams(lastId: lastId, pageSize: pageSize),
    vetSpecialtyId,
  );

  switch (res) {
    case Ok():
      return res.value!;
    case Error():
      return Future.error(res.error);
  }
}

@riverpod
Future<User> getMyUser(Ref ref) async {
  TokenResponse? token;
  try {
    token = await refreshToken();
  } catch (e) {
    return Future.error(e.toString());
  }

  final userService = UserService();
  final res = await userService.getUser(token.accessToken, token.userId);

  switch (res) {
    case Ok():
      return res.value!;
    case Error():
      return Future.error(res.error);
  }
}

@riverpod
Future<PetDaycareDetails> getMyPetDaycare(Ref ref) async {
  TokenResponse? token;
  try {
    token = await refreshToken();
  } catch (e) {
    return Future.error(e.toString());
  }

  final petDaycareService = PetDaycareService();
  final res = await petDaycareService.getMy(token.accessToken);

  switch (res) {
    case Ok():
      return res.value!;
    case Error():
      return Future.error(res.error);
  }
}

@riverpod
Future<PetDaycareDetails> getPetDaycareById(
    Ref ref, int petDaycareId, double? lat, double? long) async {
  TokenResponse? token;
  try {
    token = await refreshToken();
  } catch (e) {
    return Future.error(e.toString());
  }

  final petDaycareService = PetDaycareService();
  final res = await petDaycareService.getById(token.accessToken, petDaycareId,
      Coordinate(latitude: lat, longitude: long));

  switch (res) {
    case Ok():
      return res.value!;
    case Error():
      return Future.error(res.error);
  }
}

@riverpod
Future<ListData<BookingRequest>> getBookingRequests(Ref ref,
    [int page = 1, int pageSize = 10]) async {
  TokenResponse? token;
  try {
    token = await refreshToken();
  } catch (e) {
    return Future.error(e.toString());
  }

  final service = PetDaycareService();
  final res = await service.getBookingRequests(
    token.accessToken,
    OffsetPaginationQueryParams(page: page, pageSize: pageSize),
  );

  switch (res) {
    case Ok():
      return res.value!;
    case Error():
      return Future.error(res.error);
  }
}

@riverpod
Future<ListData<Transaction>> getTransactions(Ref ref,
    [int page = 1, int pageSize = 10]) async {
  TokenResponse? token;
  try {
    token = await refreshToken();
  } catch (e) {
    return Future.error(e.toString());
  }

  final service = TransactionService();
  final res = await service.getTransactions(
    token.accessToken,
    OffsetPaginationQueryParams(page: page, pageSize: pageSize),
  );

  switch (res) {
    case Ok():
      return res.value!;
    case Error():
      return Future.error(res.error);
  }
}

@riverpod
Future<ListData<Reviews>> getReviews(Ref ref, int petDaycareId,
    [int page = 1, int pageSize = 10]) async {
  TokenResponse? token;
  try {
    token = await refreshToken();
  } catch (e) {
    return Future.error(e.toString());
  }

  final petDaycareService = PetDaycareService();
  final res = await petDaycareService.getReviews(
      token.accessToken,
      petDaycareId,
      OffsetPaginationQueryParams(page: page, pageSize: pageSize));

  switch (res) {
    case Ok():
      return res.value!;
    case Error():
      return Future.error(res.error);
  }
}
