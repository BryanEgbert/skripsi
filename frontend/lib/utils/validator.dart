import 'package:flutter/material.dart';
import 'package:frontend/l10n/app_localizations.dart';

String? validatePassword(BuildContext context, String? value) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.passwordEmpty;
  }
  return null;
}

String? validateRegisterPassword(BuildContext context, String? value) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.passwordEmpty;
  }

  if (value.length < 8) {
    return AppLocalizations.of(context)!.passwordTooShort;
  }
  return null;
}

String? validateNotEmpty(BuildContext context, String? value) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.fieldCannotBeEmpty;
  }
  return null;
}

String? validatePriceInput(BuildContext context, bool enabled, String? value) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.priceEmpty;
  }

  String digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
  if (enabled && (double.tryParse(digitsOnly) ?? 0) <= 0) {
    return AppLocalizations.of(context)!.priceMustBeGreaterThanZero;
  }

  return null;
}

String? validateSlotInput(BuildContext context, bool enabled, String? value) {
  if (enabled && (int.tryParse(value!) ?? 0) <= 0) {
    return AppLocalizations.of(context)!.invalidSlotNumber;
  }

  return null;
}

String? validateEmail(BuildContext context, String? value) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.emailEmpty;
  }
  final bool emailIsValid = RegExp(
    r'''(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])''',
    caseSensitive: false,
  ).hasMatch(value);

  if (!emailIsValid) {
    return AppLocalizations.of(context)!.emailInvalid;
  }

  return null;
}

String? validateNextDueDate(BuildContext context, DateTime dateAdministered,
    DateTime nextDueDate, String? value) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.fieldCannotBeEmpty;
  }

  if (dateAdministered.compareTo(nextDueDate) >= 0) {
    return AppLocalizations.of(context)!.nextDueDateValidationError;
  }

  return null;
}
