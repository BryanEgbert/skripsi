import 'dart:io';

class VaccinationRecordRequest {
  final File? vaccineRecordImage;
  final String dateAdministered;
  final String nextDueDate;

  VaccinationRecordRequest(
      {required this.vaccineRecordImage,
      required this.dateAdministered,
      required this.nextDueDate});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "dateAdministered": dateAdministered,
      "nextDueDate": nextDueDate,
    };

    return map;
  }

  @override
  String toString() {
    return "VaccinationRecordRequest(dateAdministered: $dateAdministered, nextDueDate: $nextDueDate)";
  }
}
