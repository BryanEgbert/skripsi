import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/pages/signup/create_pet.dart';
import 'package:frontend/utils/validator.dart';

class UserDetailsForm extends ConsumerStatefulWidget {
  final VoidCallback onSubmit;
  const UserDetailsForm({
    super.key,
    required this.onSubmit,
  });

  @override
  ConsumerState<UserDetailsForm> createState() =>
      _UserDetailsFormComponentState();
}

class _UserDetailsFormComponentState extends ConsumerState<UserDetailsForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          // TODO: implement image picker logic
          IconButton.filled(
            key: Key("image-picker"),
            onPressed: () {},
            style: IconButton.styleFrom(
              shape: CircleBorder(),
              minimumSize: Size(100, 100),
            ),
            icon: Icon(
              Icons.add_a_photo_rounded,
              size: 32,
            ),
          ),
          SizedBox(height: 0),
          TextFormField(
            key: Key("name-input"),
            // controller: _passwordEditingController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              labelText: "Display Name",
            ),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextFormField(
            key: Key("email-input"),
            // controller: _emailEditingController,
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
          TextFormField(
            key: Key("password-input"),
            // controller: _passwordEditingController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              labelText: "Password",
            ),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            validator: (value) {
              return validatePassword(value);
            },
          ),
          ElevatedButton(
            onPressed: widget.onSubmit,
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }
}
