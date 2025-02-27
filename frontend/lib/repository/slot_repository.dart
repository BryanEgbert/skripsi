import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/request/book_slot_request.dart';
import 'package:frontend/model/request/reduce_slot_request.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/slot.dart';

abstract interface class ISlotRepository {
  Future<Result<ListData<Slot>>> getSlots(String token, int speciesId,
      int petDaycareid, int year, int month, PaginationQueryParams pagination);
  Future<Result<void>> bookSlot(
      String token, int petDaycareId, BookSlotRequest reqBody);
  Future<Result<void>> editSlotCount(
      String token, int slotId, ReduceSlotRequest reqBody);
}

class SlotRepository implements ISlotRepository {
  @override
  Future<Result<void>> bookSlot(
      String token, int petDaycareId, BookSlotRequest reqBody) {
    // TODO: implement bookSlot
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> editSlotCount(
      String token, int slotId, ReduceSlotRequest reqBody) {
    // TODO: implement editSlotCount
    throw UnimplementedError();
  }

  @override
  Future<Result<ListData<Slot>>> getSlots(String token, int speciesId,
      int petDaycareid, int year, int month, PaginationQueryParams pagination) {
    // TODO: implement getSlots
    throw UnimplementedError();
  }
}
