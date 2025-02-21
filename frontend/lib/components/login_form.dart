import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/utils/validator.dart';

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

  Future<void>? _futureTokenResponse;

  @override
  Widget build(BuildContext context) {
    var auth = ref.read(authProvider.notifier);

    return FutureBuilder(
        future: _futureTokenResponse,
        builder: (context, snapshot) {
          if (snapshot.hasError &&
              snapshot.connectionState != ConnectionState.waiting) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              var snackbar = SnackBar(
                content: Text(snapshot.error.toString()),
                backgroundColor: Colors.red,
              );

              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            });
          }

          return Form(
            key: formGlobalKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
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
                FilledButton(
                  onPressed: () {
                    if (snapshot.connectionState != ConnectionState.waiting ||
                        snapshot.connectionState == ConnectionState.done) {
                      if (formGlobalKey.currentState!.validate()) {
                        // TODO: login
                        final future = auth.login(_emailEditingController.text,
                            _passwordEditingController.text);
                        setState(() {
                          _futureTokenResponse = future;
                        });
                      }
                    }
                  },
                  child: Text(
                      (snapshot.connectionState != ConnectionState.waiting)
                          ? "Login"
                          : "Logging In..."),
                ),
              ],
            ),
          );
        });
  }
}
