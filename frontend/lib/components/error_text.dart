import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/pages/welcome.dart';

class ErrorText extends StatefulWidget {
  final String errorText;
  final Function() onRefresh;

  const ErrorText(
      {super.key, required this.errorText, required this.onRefresh});

  @override
  State<ErrorText> createState() => _ErrorTextState();
}

class _ErrorTextState extends State<ErrorText> {
  @override
  Widget build(BuildContext context) {
    if (widget.errorText.toString() == jwtExpired) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => WelcomeWidget(),
            ),
            (route) => false,
          );
        },
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.errorText.toString()),
          IconButton(
            onPressed: widget.onRefresh,
            icon: Icon(
              Icons.refresh,
              color: Colors.orange,
            ),
          )
        ],
      ),
    );
  }
}
