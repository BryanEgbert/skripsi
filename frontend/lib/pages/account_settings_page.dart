import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/pages/edit/edit_user_page.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/theme_provider.dart';

class AccountSettingsPage extends ConsumerStatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  ConsumerState<AccountSettingsPage> createState() =>
      _AccountSettingsPageState();
}

class _AccountSettingsPageState extends ConsumerState<AccountSettingsPage> {
  @override
  Widget build(BuildContext context) {
    // final auth = ref.watch(authProvider);
    final themeMode = ref.watch(themeStateProvider);
    // if (!auth.hasError)

    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Constants.secondaryBackgroundColor,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            "Account Settings",
            style: TextStyle(color: Colors.orange),
          ),
        ),
        body: switch (themeMode) {
          AsyncError(:final error) => ErrorText(
              errorText: error.toString(),
              onRefresh: () => ref.refresh(themeStateProvider.future)),
          AsyncData(:final value) => ListView.custom(
              childrenDelegate: SliverChildListDelegate.fixed([
                ListTile(
                  title: Text("Edit Profile"),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditUserPage(),
                    ));
                  },
                ),
                SwitchListTile.adaptive(
                  value: value,
                  onChanged: (value) {
                    ref.read(themeStateProvider.notifier).setMode();
                  },
                  title: Text("Dark Mode"),
                ),
                ListTile(
                  onTap: () {
                    ref.read(authProvider.notifier).logOut();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => WelcomeWidget()),
                      (route) => false,
                    );
                  },
                  title: Text(
                    "Logout",
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
