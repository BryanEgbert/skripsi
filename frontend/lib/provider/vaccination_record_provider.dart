import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/request/vaccination_record_request.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/services/vaccination_record_service.dart';
import 'package:frontend/utils/refresh_token.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vaccination_record_provider.g.dart';

@riverpod
class VaccinationRecordState extends _$VaccinationRecordState {
  @override
  Future<int> build() {
    return Future.value(0);
  }

  Future<void> reset() async {
    state = AsyncData(0);
  }

  Future<void> create(int petId, VaccinationRecordRequest req) async {
    TokenResponse token = await refreshToken();

    final service = VaccinationRecordService();
    final res = await service.create(token.accessToken, petId, req);

    switch (res) {
      case Ok():
        state = AsyncData(201);
      case Error():
        state = AsyncError(res.error, StackTrace.current);
    }
  }

  Future<void> updateRecord(
      int petId, int vaccinationRecordId, VaccinationRecordRequest req) async {
    TokenResponse token = await refreshToken();

    final service = VaccinationRecordService();
    final res =
        await service.update(token.accessToken, vaccinationRecordId, req);

    switch (res) {
      case Ok():
        state = AsyncData(204);
        ref.invalidate(vaccineRecordsProvider(petId));

      case Error():
        state = AsyncError(res.error, StackTrace.current);
    }
  }

  Future<void> delete(int vaccinationRecordId, int petId, int pageSize) async {
    TokenResponse token = await refreshToken();

    final service = VaccinationRecordService();
    final res = await service.delete(token.accessToken, vaccinationRecordId);

    switch (res) {
      case Ok():
        state = AsyncData(204);
        ref.invalidate(vaccineRecordsProvider(petId, 0, pageSize));
      case Error():
        state = AsyncError(res.error, StackTrace.current);
    }
  }
}
