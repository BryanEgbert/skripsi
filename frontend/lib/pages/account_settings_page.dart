import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/components/modals/select_language_modal.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/pages/edit/edit_user_page.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/locale_provider.dart';
import 'package:frontend/provider/theme_provider.dart';
import 'package:frontend/services/localization_service.dart';

class AccountSettingsPage extends ConsumerStatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  ConsumerState<AccountSettingsPage> createState() =>
      _AccountSettingsPageState();
}

class _AccountSettingsPageState extends ConsumerState<AccountSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final localeState = ref.watch(localeStateProvider);
    final themeMode = ref.watch(themeStateProvider);

    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Constants.secondaryBackgroundColor,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.primaryTextColor
                  : Colors.orange,
            ),
          ),
          title: Text(
            AppLocalizations.of(context)!.accountSettings,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.primaryTextColor
                  : Colors.orange,
            ),
          ),
        ),
        body: switch (themeMode) {
          AsyncError(:final error) => ErrorText(
              errorText: error.toString(),
              onRefresh: () => ref.refresh(themeStateProvider.future)),
          AsyncData(:final value) => ListView.custom(
              childrenDelegate: SliverChildListDelegate.fixed([
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text(AppLocalizations.of(context)!.editProfile),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditUserPage(),
                    ));
                  },
                ),
                ListTile(
                  onTap: () async {
                    await showModalBottomSheet(
                      context: context,
                      builder: (context) => SelectLanguageModal(),
                    );

                    LocalizationService().load(context);
                  },
                  leading: Icon(Icons.language),
                  title: Text(AppLocalizations.of(context)!.preferredLanguage),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localeState.value!.toUpperCase(),
                        style: TextStyle(fontSize: 14),
                      ),
                      Icon(Icons.navigate_next),
                    ],
                  ),
                ),
                SwitchListTile.adaptive(
                  value: value,
                  secondary: Icon(Icons.dark_mode),
                  onChanged: (value) {
                    ref.read(themeStateProvider.notifier).setMode();
                  },
                  title: Text(AppLocalizations.of(context)!.darkMode),
                ),
                ListTile(
                  onTap: () {
                    ref.read(authProvider.notifier).logOut();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => WelcomeWidget()),
                      (route) => false,
                    );
                  },
                  leading: Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.logout,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ]),
            ),
          _ => Center(
              child: CircularProgressIndicator.adaptive(),
            ),
        });
  }
}
