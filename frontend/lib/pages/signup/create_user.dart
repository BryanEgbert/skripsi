import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/profile_image_picker.dart';
import 'package:frontend/components/signup_guide_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/request/create_user_request.dart';
import 'package:frontend/pages/signup/create_pet_daycare_page.dart';
import 'package:frontend/pages/signup/create_vet.dart';
import 'package:frontend/pages/signup/enter_pet_details_page.dart';
import 'package:frontend/utils/validator.dart';
import 'package:image_picker/image_picker.dart';

class CreateUserPage extends StatefulWidget {
  final int roleId;
  const CreateUserPage({super.key, required this.roleId});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  File? _userProfilePicture;
  bool _revealPassword = false;

  Future<void> _pickImage() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (photo != null) {
      setState(() {
        _userProfilePicture = File(photo.path);
        log("profile: ${_userProfilePicture!.path}");
      });
    }
  }

  Future<void> _navigateToNext() async {
    final createUserReq = CreateUserRequest(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      roleId: widget.roleId,
      userImage: _userProfilePicture,
      vetSpecialtyId: [],
      deviceToken: await FirebaseMessaging.instance.getToken(),
    );
    if (_formKey.currentState!.validate()) {
      if (!mounted) return;
      if (widget.roleId == 1) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EnterPetDetailsPage(
                  createUserReq: createUserReq,
                )));
      } else if (widget.roleId == 2) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CreatePetDaycarePage(
            createUserReq: createUserReq,
          ),
        ));
      } else if (widget.roleId == 3) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CreateVetPage(
            reqBody: createUserReq,
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).brightness == Brightness.light
                ? Constants.primaryTextColor
                : Colors.orange,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SignupGuideText(
                  title: AppLocalizations.of(context)!.setupAccountTitle,
                  subtitle: AppLocalizations.of(context)!.setupAccountSubtitle,
                ),
                SizedBox(height: 56),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 12,
                    children: [
                      ProfileImagePicker(
                        onTap: _pickImage,
                        image: _userProfilePicture,
                      ),
                      TextFormField(
                        key: Key("name-input"),
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: AppLocalizations.of(context)!.displayName,
                        ),
                        validator: (value) => validateNotEmpty(context, value),
                      ),
                      TextFormField(
                        key: Key("email-input"),
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: "Email",
                          helper: Text(
                            "e.g. test@gmail.com",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white70,
                            ),
                          ),
                        ),
                        validator: (value) {
                          return validateEmail(context, value);
                        },
                      ),
                      TextFormField(
                        key: Key("password-input"),
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffix: GestureDetector(
                            onTap: () {
                              setState(() {
                                _revealPassword =
                                    _revealPassword ? false : true;
                              });
                            },
                            child: (!_revealPassword)
                                ? Icon(
                                    Icons.visibility,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Constants.primaryTextColor
                                        : Colors.orange,
                                  )
                                : Icon(
                                    Icons.visibility_off,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Constants.primaryTextColor
                                        : Colors.orange,
                                  ),
                          ),
                          labelText:
                              AppLocalizations.of(context)!.passwordInputLabel,
                          helper: Text(
                            AppLocalizations.of(context)!.passwordRequirement,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white70,
                            ),
                          ),
                        ),
                        obscureText: !_revealPassword,
                        enableSuggestions: false,
                        autocorrect: false,
                        validator: (value) {
                          return validateRegisterPassword(context, value);
                        },
                      ),
                      ElevatedButton(
                        onPressed: _navigateToNext,
                        child: Text(AppLocalizations.of(context)!.next),
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

  Widget profilePicturePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Column(
        children: [
          Stack(
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
                    ? Icon(Icons.person, size: 40, color: Colors.grey[700])
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
          Text(
            "Edit Photo",
            style: TextStyle(color: Colors.orange[800]),
          ),
        ],
      ),
    );
  }
}
