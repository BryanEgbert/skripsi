import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/coordinate.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/pet_daycare.dart';
import 'package:frontend/model/request/pet_daycare_filters.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/database_service.dart';
import 'package:frontend/services/pet_daycare_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'list_data_provider.g.dart';

@riverpod
Future<ListData<PetDaycare>> petDaycares(
    Ref ref, double lat, double long) async {
  final dbService = DatabaseService();
  final authService = AuthService();

  final token = await dbService.getToken();

  if (token.expiryDate >= DateTime.now().millisecondsSinceEpoch / 1000) {
    final refreshRes = await authService.refreshToken(token.refreshToken);
    switch (refreshRes) {
      case Ok<TokenResponse>():
        break;
      case Error<TokenResponse>():
        return Future.error(jwtExpired);
    }
  }

  final petDaycareService = PetDaycareService();

  final daycares = await petDaycareService.getPetDaycares(
    token.accessToken,
    Coordinate(latitude: lat, longitude: long),
    PetDaycareFilters(),
    PaginationQueryParams(),
  );

  switch (daycares) {
    case Ok():
      return daycares.value!;
    case Error():
      return Future.error(daycares.error);
  }
}
