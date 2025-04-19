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
        content: Text(providerValue.error.toString()),
        backgroundColor: Colors.red,
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
}
