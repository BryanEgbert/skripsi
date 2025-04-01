import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/utils/validator.dart';
import 'package:image_picker/image_picker.dart';

class UserDetailsForm extends ConsumerStatefulWidget {
  File? userProfilePicture;

  final VoidCallback onSubmit;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  UserDetailsForm({
    super.key,
    required this.onSubmit,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    this.userProfilePicture,
  });

  @override
  ConsumerState<UserDetailsForm> createState() =>
      _UserDetailsFormComponentState();
}

class _UserDetailsFormComponentState extends ConsumerState<UserDetailsForm> {
  Future<void> _pickImage() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (photo != null) {
      setState(() {
        widget.userProfilePicture = File(photo.path);
        log("profile: ${widget.userProfilePicture!.path}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: widget.userProfilePicture != null
                        ? DecorationImage(
                            image: FileImage(widget.userProfilePicture!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: Colors.grey[300],
                  ),
                  child: widget.userProfilePicture == null
                      ? Icon(Icons.edit, size: 40, color: Colors.grey[700])
                      : null,
                ),
                if (widget.userProfilePicture != null)
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
