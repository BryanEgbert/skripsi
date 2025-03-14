import 'package:flutter/material.dart';

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
      margin: EdgeInsets.only(top: 64),
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
            text: "$title\n",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
            children: [
              TextSpan(
                text: subtitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Color(0xff222222),
                ),
              ),
            ]),
      ),
    );
  }
}
