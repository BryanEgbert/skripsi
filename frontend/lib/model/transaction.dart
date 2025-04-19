import 'package:freezed_annotation/freezed_annotation.dart';
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
    required String startDate,
    required String endDate,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
