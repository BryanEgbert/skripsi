import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/components/profile_image_picker.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/request/update_user_request.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/provider/category_provider.dart';
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
  List<int> _vetSpecialties = [];
  File? _userProfilePicture;

  bool _isLoaded = false;

  Future<void> _pickImage() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (photo != null) {
      setState(() {
        _userProfilePicture = File(photo.path);
      });
    }
  }

  void _submitForm(User value) {
    final updateUserReq = UpdateUserRequest(
      name: _nameController.text,
      image: _userProfilePicture,
      email: value.email,
      roleId: value.role.id,
      vetSpecialtyId: _vetSpecialties,
    );

    ref.read(userStateProvider.notifier).editUser(updateUserReq);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(getMyUserProvider);
    final userState = ref.watch(userStateProvider);
    final vetSpecialties = ref.watch(vetSpecialtiesProvider);

    handleValue(userState, this, ref.read(userStateProvider.notifier).reset);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).brightness == Brightness.light
                    ? Constants.primaryTextColor
                    : Colors.orange,
              )),
          title: Text(
            AppLocalizations.of(context)!.editUserProfile,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.primaryTextColor
                  : Colors.orange,
            ),
          ),
        ),
        body: switch (user) {
          AsyncError(:final error) => ErrorText(
              errorText: error.toString(),
              onRefresh: () => ref.refresh(getMyUserProvider.future)),
          AsyncData(:final value) => SafeArea(
              child: Builder(builder: (context) {
                if (!_isLoaded) {
                  _nameController.text = value.name;
                  _vetSpecialties =
                      value.vetSpecialties.map((e) => e.id).toList();
                  _isLoaded = true;
                }

                return Container(
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
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white70,
                          ),
                          key: Key("name-input"),
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelText:
                                AppLocalizations.of(context)!.displayName,
                          ),
                          validator: (value) =>
                              validateNotEmpty(context, value),
                        ),
                        if (value.role.id == 3) ...[
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.chooseVetSpecialties,
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Constants.primaryTextColor
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: vetSpecialties.value!.length,
                              itemBuilder: (context, index) {
                                return CheckboxListTile(
                                  value: _vetSpecialties.contains(
                                      vetSpecialties.value![index].id),
                                  title:
                                      Text(vetSpecialties.value![index].name),
                                  onChanged: (isChecked) {
                                    setState(() {
                                      if (isChecked == true) {
                                        _vetSpecialties.add(
                                            vetSpecialties.value![index].id);
                                      } else {
                                        _vetSpecialties.remove(
                                            vetSpecialties.value![index].id);
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                        ElevatedButton(
                          onPressed: () async {
                            _submitForm(value);
                          },
                          child: !userState.isLoading
                              ? Text(AppLocalizations.of(context)!.saveBtn)
                              : CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          _ => Center(child: CircularProgressIndicator.adaptive())
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
