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
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
      .hasMatch(value);

  if (!emailIsValid) {
    return AppLocalizations.of(context)!.emailInvalid;
  }

  return null;
}
