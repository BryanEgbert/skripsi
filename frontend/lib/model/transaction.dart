import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/model/booked_slot_address.dart';
import 'package:frontend/model/booking_request.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/model/pet_daycare.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
class Transaction with _$Transaction {
  factory Transaction({
    required int id,
    required Lookup status,
    required PetDaycareDetails petDaycare,
    // required List<Pet> bookedPet,
    required String startDate,
    required String endDate,
    required BookingRequest bookedSlot,
    required BookedSlotAddress? addressInfo,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
