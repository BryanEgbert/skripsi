import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDateStr(String dateString, BuildContext context) {
  DateTime dateTime = DateTime.parse(dateString).toLocal();
  Locale locale = Localizations.localeOf(context);
  return DateFormat('dd MMMM yyyy', locale.toLanguageTag()).format(dateTime);
}

String formatDate(DateTime date, BuildContext context) {
  Locale locale = Localizations.localeOf(context);
  return DateFormat('dd MMMM yyyy', locale.toLanguageTag()).format(date);
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

String formatNumber(int number, String locale) {
  final formatter = NumberFormat.compact(locale: locale);

  // if (number >= 1000000000) {
  //   return '${(number / 1000000000).toStringAsFixed(1)}B';
  // } else if (number >= 1000000) {
  //   return '${(number / 1000000).toStringAsFixed(1)}M';
  // } else if (number >= 1000) {
  //   return '${(number / 1000).toStringAsFixed(1)}k';
  // } else {
  //   return number.toString();
  // }
  return formatter.format(number);
}
