import 'package:frontend/model/coordinate.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/pet_daycare.dart';
import 'package:frontend/model/request/pet_daycare_filters.dart';
import 'package:frontend/model/response/list_response.dart';

abstract interface class IPetDaycareService {
  Future<Result<PetDaycareDetails>> getById(
      String token, int petDaycareId, Coordinate coord);
  Future<Result<ListData<PetDaycare>>> getPetDaycares(
      String token,
      Coordinate coord,
      PetDaycareFilters filters,
      PaginationQueryParams pagination);
  // Future<Result<void>> createPetDaycare(String token, )
  Future<Result<void>> deletePetDaycare(String token, int petDaycareId);
}
