import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void handleError(AsyncValue providerValue, BuildContext context) {
  if (providerValue.hasError && !providerValue.isLoading) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var snackbar = SnackBar(
        key: Key("error-message"),
        content: Text(providerValue.error.toString()),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    });
  }
}
