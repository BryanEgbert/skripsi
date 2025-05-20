import 'package:intl/intl.dart';

String formatDateStr(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  return DateFormat('dd MMMM yyyy').format(dateTime);
}

String formatDate(DateTime date) {
  return DateFormat('dd MMMM yyyy').format(date);
}

String toRfc3339WithOffset(DateTime dateTime) {
  final offset = dateTime.timeZoneOffset;
  final hours = offset.inHours.abs().toString().padLeft(2, '0');
  final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
  final sign = offset.isNegative ? '-' : '+';

  final formattedOffset = '$sign$hours:$minutes';
  final formattedDate = dateTime.toIso8601String().split('.').first;

  return '$formattedDate$formattedOffset';
}
