import 'package:flutter/material.dart';
import 'package:frontend/components/app_welcome_text.dart';
import 'package:frontend/components/login_form.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/pages/signup/pick_role_page.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppWelcomeText(),
                SizedBox(
                  height: 64,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LoginForm(),
                    separator(),
                    createAccountButton(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createAccountButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const PickRolePage()),
        );
      },
      child: Text(
        AppLocalizations.of(context)!.createAnAccountBtn,
      ),
    );
  }

  Widget separator() {
    return Builder(builder: (context) {
      return Row(
        children: <Widget>[
          Expanded(child: Divider()),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(AppLocalizations.of(context)!.or),
          ),
          Expanded(child: Divider()),
        ],
      );
    });
  }
}
