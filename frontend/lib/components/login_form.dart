import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/pages/pet_daycare_home_page.dart';
import 'package:frontend/pages/vet_main_page.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/utils/validator.dart';
import 'package:frontend/pages/home.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final formGlobalKey = GlobalKey<FormState>();

  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    AsyncValue<TokenResponse?> auth = ref.watch(authProvider);

    if (auth.hasError && !auth.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        var snackbar = SnackBar(
          key: Key("error-message"),
          content: Text(auth.error.toString()),
          backgroundColor: Colors.red,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      });
    }

    if (auth.value != null && !auth.isLoading) {
      if (auth.value!.roleId == 1) {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomeWidget(),
            ),
            (route) => false,
          ),
        );
      } else if (auth.value!.roleId == 2) {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => PetDaycareHomePage(),
            ),
            (route) => false,
          ),
        );
      } else {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => VetMainPage(),
            ),
            (route) => false,
          ),
        );
      }
    }

    return Form(
      key: formGlobalKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white70,
            ),
            key: Key("email-input"),
            controller: _emailEditingController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              labelText: "Email",
            ),
            validator: (value) {
              return validateEmail(value);
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white70,
            ),
            key: Key("password-input"),
            controller: _passwordEditingController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              labelText: "Password",
            ),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
            key: Key("submit-btn"),
            onPressed: () async {
              if (!auth.isLoading) {
                if (formGlobalKey.currentState!.validate()) {
                  await ref.read(authProvider.notifier).login(
                      _emailEditingController.text,
                      _passwordEditingController.text);
                }
              }
            },
            child: Text(
              (auth.isLoading) ? "Logging In..." : "Login",
            ),
          ),
        ],
      ),
    );
  }
}
