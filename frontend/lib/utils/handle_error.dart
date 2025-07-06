import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/services/localization_service.dart';

void handleError(AsyncValue providerValue, BuildContext context,
    [Function()? reset]) {
  if (providerValue.hasError &&
      (providerValue.valueOrNull == null || providerValue.valueOrNull == 0) &&
      !providerValue.isLoading) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scaffoldMessenger.hideCurrentSnackBar();
      var snackbar = SnackBar(
        key: Key("error-message"),
        content: Text(
          providerValue.error.toString(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[800],
      );

      scaffoldMessenger.showSnackBar(snackbar);

      if (providerValue.error.toString() == LocalizationService().jwtExpired ||
          providerValue.error.toString() == LocalizationService().userDeleted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => WelcomeWidget(),
          ),
          (route) => false,
        );
      }

      if (reset != null) reset();
    });
  }
}

void handleValue(AsyncValue providerValue, State state, [Function()? reset]) {
  var context = state.context;
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  handleError(providerValue, context, reset);

  if (providerValue.hasValue && !providerValue.isLoading) {
    if (providerValue.value == null) return;

    if (providerValue.value is int) {
      if (providerValue.value >= 200 && providerValue.value <= 400) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (!state.mounted) return;
          scaffoldMessenger.hideCurrentSnackBar();

          var snackbar = SnackBar(
            key: Key("success-message"),
            content: Text(
              AppLocalizations.of(context)!.operationSuccess,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.green[800],
          );

          scaffoldMessenger.showSnackBar(snackbar);

          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }

          if (reset != null) {
            log("running reset");
            reset();
          }
        });
      }

      return;
    }
  }
}
