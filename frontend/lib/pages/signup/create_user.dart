import 'package:flutter/material.dart';
import 'package:frontend/components/signup_guide_text.dart';
import 'package:frontend/components/user_details_form.dart';
import 'package:frontend/utils/validator.dart';
import 'package:frontend/pages/signup/create_pet.dart';

class CreateUserPage extends StatelessWidget {
  final int roleId;
  const CreateUserPage({super.key, required this.roleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SignupGuideText(
                title: "Let's Set Up Your Account",
                subtitle: "Enter your details to continue",
              ),
              SizedBox(height: 56),
              UserDetailsForm(
                // TODO: add navigation based on role ID
                onSubmit: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CreatePetPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
