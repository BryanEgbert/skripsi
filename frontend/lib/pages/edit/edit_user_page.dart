import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/components/profile_image_picker.dart';
import 'package:frontend/model/request/update_user_request.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/user_provider.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/validator.dart';
import 'package:image_picker/image_picker.dart';

class EditUserPage extends ConsumerStatefulWidget {
  const EditUserPage({super.key});

  @override
  ConsumerState<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends ConsumerState<EditUserPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  File? _userProfilePicture;

  Future<void> _pickImage() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (photo != null) {
      setState(() {
        _userProfilePicture = File(photo.path);
        // log("profile: ${_userProfilePicture!.path}");
      });
    }
  }

  void _submitForm(UserState userState, User value) {
    final updateUserReq = UpdateUserRequest(
      name: _nameController.text,
      image: _userProfilePicture,
      email: value.email,
      roleId: value.role.id,
      vetSpecialtyId: value.vetSpecialties.isNotEmpty
          ? value.vetSpecialties.map((e) => e!.id).toList()
          : [],
    );

    userState.editUser(updateUserReq);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(getMyUserProvider);
    final userState = ref.watch(userStateProvider);

    handleError(userState, context);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back_ios)),
          title: Text(
            "Edit User Profile",
            style: TextStyle(color: Colors.orange),
          ),
        ),
        body: switch (user) {
          AsyncError(:final error) => ErrorText(
              errorText: error.toString(),
              onRefresh: () => ref.refresh(getMyUserProvider.future)),
          AsyncData(:final value) => SafeArea(
              child: Builder(builder: (context) {
                _nameController.text = value.name;

                return SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 12,
                        children: [
                          ProfileImagePicker(
                            onTap: _pickImage,
                            image: _userProfilePicture,
                            imageUrl:
                                (value.imageUrl == "") ? null : value.imageUrl,
                          ),
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
                            validator: (value) =>
                                validateNotEmpty("Name", value),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              _submitForm(
                                ref.read(userStateProvider.notifier),
                                value,
                              );
                            },
                            child: const Text("Save"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          _ => Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
        });
  }

  Widget profilePicturePicker() {
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
