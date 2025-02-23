import 'package:flutter/material.dart';
import 'package:frontend/utils/validator.dart';
import 'package:frontend/widgets/create_pet.dart';

class CreatePetOwnerPage extends StatefulWidget {
  const CreatePetOwnerPage({super.key});

  @override
  State<CreatePetOwnerPage> createState() => _CreatePetOwnerPageState();
}

class _CreatePetOwnerPageState extends State<CreatePetOwnerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              IconButton.filled(
                key: Key("image-picker"),
                onPressed: () {},
                style: IconButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(32),
                ),
                icon: Icon(
                  Icons.add_a_photo_rounded,
                  size: 42,
                ),
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
              FilledButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreatePetPage(),
                      ));
                },
                child: const Text("Next"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
