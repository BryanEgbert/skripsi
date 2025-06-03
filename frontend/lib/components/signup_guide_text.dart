import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

class SignupGuideText extends StatelessWidget {
  final String title;
  final String subtitle;

  const SignupGuideText({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 52),
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
            text: "$title\n",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.primaryTextColor
                  : Colors.orange,
            ),
            children: [
              TextSpan(
                text: subtitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ]),
      ),
    );
  }
}
