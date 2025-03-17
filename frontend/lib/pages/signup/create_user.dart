import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/components/signup_guide_text.dart';
import 'package:frontend/components/user_details_form.dart';
import 'package:frontend/model/request/create_user_request.dart';
import 'package:frontend/pages/signup/create_vet.dart';
import 'package:frontend/utils/validator.dart';
import 'package:frontend/pages/signup/create_pet.dart';
import 'package:image_picker/image_picker.dart';

class CreateUserPage extends StatefulWidget {
  final int roleId;
  const CreateUserPage({super.key, required this.roleId});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  File? _userProfilePicture;

  Future<void> _pickImage() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (photo != null) {
      setState(() {
        _userProfilePicture = File(photo.path);
        log("profile: ${_userProfilePicture!.path}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 12,
                    children: [
                      profilePicturePicker(),
                      SizedBox(height: 0),
                      TextFormField(
                        key: Key("name-input"),
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: "Display Name",
                        ),
                      ),
                      TextFormField(
                        key: Key("email-input"),
                        controller: _emailController,
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
                        controller: _passwordController,
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
                        onPressed: () {
                          if (widget.roleId == 1) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CreatePetPage(),
                              ),
                            );
                          } else if (widget.roleId == 3) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CreateVetPage(
                                  reqBody: CreateUserRequest(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    roleId: widget.roleId,
                                    image: _userProfilePicture,
                                    vetSpecialtyId: [],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CreatePetPage(),
                              ),
                            );
                          }
                        },
                        child: const Text("Next"),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector profilePicturePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: _userProfilePicture != null
                  ? DecorationImage(
                      image: FileImage(_userProfilePicture!),
                      fit: BoxFit.cover,
                    )
                  : null,
              color: Colors.grey[300],
            ),
            child: _userProfilePicture == null
                ? Icon(Icons.edit, size: 40, color: Colors.grey[700])
                : null,
          ),
          if (_userProfilePicture != null)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black54,
              ),
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }
}
