import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/pages/welcome.dart';

void handleError(AsyncValue providerValue, BuildContext context,
    [Function()? reset]) {
  if (providerValue.hasError &&
      (providerValue.valueOrNull == null || providerValue.valueOrNull == 0) &&
      !providerValue.isLoading) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      var snackbar = SnackBar(
        key: Key("error-message"),
        content: Text(
          providerValue.error.toString(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[800],
      );

      ScaffoldMessenger.of(context).showSnackBar(snackbar);

      if (providerValue.error.toString() == jwtExpired ||
          providerValue.error.toString() == userDeleted) {
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
  if (!state.mounted) return;

  if (providerValue.hasError &&
      (providerValue.valueOrNull == null || providerValue.valueOrNull == 0) &&
      !providerValue.isLoading) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      var snackbar = SnackBar(
        key: Key("error-message"),
        content: Text(
          providerValue.error.toString(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[800],
      );

      ScaffoldMessenger.of(context).showSnackBar(snackbar);

      if (providerValue.error.toString() == jwtExpired ||
          providerValue.error.toString() == userDeleted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => WelcomeWidget(),
          ),
          (route) => false,
        );
      }

      if (reset != null) reset();
    });

    return;
  }

  if (providerValue.hasValue && !providerValue.isLoading) {
    if (providerValue.value == null) return;
    log("wahoo");
    if (providerValue.value is int) {
      if (providerValue.value >= 200 && providerValue.value <= 400) {
        log("show snackbar");
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          var snackbar = SnackBar(
            key: Key("success-message"),
            content: Text(
              "Operation completed successfully",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.green[800],
          );

          ScaffoldMessenger.of(context).showSnackBar(snackbar);

          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }

          if (reset != null) reset();
        });
      } else {
        return;
      }
    }
  }
}
