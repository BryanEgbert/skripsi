import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';

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
            text: TextSpan(
              text: "${AppLocalizations.of(context)!.welcomeTo}\n",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
              children: [
                TextSpan(
                  text: "PawConnect\n",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Constants.primaryTextColor
                        : Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                TextSpan(
                  text: AppLocalizations.of(context)!.punchLine,
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
