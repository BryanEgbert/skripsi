import 'package:flutter/material.dart';

class AppWelcomeText extends StatelessWidget {
  const AppWelcomeText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textAlign: TextAlign.start,
            text: const TextSpan(
              text: "Welcome to\n",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: "AppName\n",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                TextSpan(
                  text:
                      "The smarter way to find pet daycares & connect with vets!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
