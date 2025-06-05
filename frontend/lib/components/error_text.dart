import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/services/localization_service.dart';

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
    if (widget.errorText == LocalizationService().jwtExpired ||
        widget.errorText == LocalizationService().userDeleted) {
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
          Text(
            widget.errorText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          IconButton(
            onPressed: widget.onRefresh,
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.primaryTextColor
                  : Colors.orange,
            ),
          )
        ],
      ),
    );
  }
}
