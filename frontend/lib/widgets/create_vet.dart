import 'package:flutter/material.dart';
import 'package:frontend/utils/validator.dart';

class CreateVetPage extends StatefulWidget {
  const CreateVetPage({super.key});

  @override
  State<CreateVetPage> createState() => _CreateVetPageState();
}

class _CreateVetPageState extends State<CreateVetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Column(
          children: [
            IconButton.filled(
              key: Key("image-picker"),
              onPressed: () {},
              style: IconButton.styleFrom(
                shape: CircleBorder(),
              ),
              icon: Icon(Icons.add_a_photo_rounded),
            ),
            TextFormField(
              key: Key("name-input"),
              // controller: _passwordEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                labelText: "Name",
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
            const SizedBox(
              height: 8,
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
            InkWell(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Choose vet specialties"),
                  const Icon(Icons.arrow_forward_ios_rounded),
                ],
              ),
            ),
            FilledButton(
              onPressed: () {},
              child: const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}
