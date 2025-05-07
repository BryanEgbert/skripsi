import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/pages/welcome.dart';

void handleError(AsyncValue providerValue, BuildContext context) {
  if (providerValue.hasError &&
      !providerValue.hasValue &&
      !providerValue.isLoading) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var snackbar = SnackBar(
        key: Key("error-message"),
        content: Text(
          providerValue.error.toString(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[800],
      );

      ScaffoldMessenger.of(context).showSnackBar(snackbar);

      if (providerValue.error.toString() == jwtExpired) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => WelcomeWidget(),
          ),
          (route) => false,
        );
      }
    });
  }

  if (providerValue.hasValue && !providerValue.isLoading) {
    if (providerValue.value >= 200 && providerValue.value <= 400) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        var snackbar = SnackBar(
          key: Key("success-message"),
          content: Text("Operation completed successfully"),
          backgroundColor: Colors.green[800],
        );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
    }
  }
}
