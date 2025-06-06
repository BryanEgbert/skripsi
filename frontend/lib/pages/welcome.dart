import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/app_welcome_text.dart';
import 'package:frontend/components/login_form.dart';
import 'package:frontend/components/modals/select_language_modal.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/pages/signup/pick_role_page.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 32,
                right: 16,
                child: GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => SelectLanguageModal(),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CountryFlag.fromLanguageCode(
                        Localizations.localeOf(context).toLanguageTag(),
                        shape: RoundedRectangle(4),
                        width: 24,
                        height: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        Localizations.localeOf(context)
                            .toLanguageTag()
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Constants.primaryTextColor
                                  : Colors.orange,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Constants.primaryTextColor
                            : Colors.orange,
                      )
                    ],
                  ),
                ),
              ),
              Center(
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
                          _separator(),
                          _createAccountButton(context),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createAccountButton(BuildContext context) {
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

  Widget _separator() {
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
