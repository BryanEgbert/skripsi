import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/modals/select_pet_type_modal.dart';
import 'package:frontend/components/profile_image_picker.dart';
import 'package:frontend/components/signup_guide_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/model/request/create_user_request.dart';
import 'package:frontend/model/request/pet_request.dart';
import 'package:frontend/pages/signup/create_vaccination_records_page.dart';
import 'package:frontend/utils/validator.dart';
import 'package:image_picker/image_picker.dart';

class EnterPetDetailsPage extends ConsumerStatefulWidget {
  final CreateUserRequest createUserReq;

  const EnterPetDetailsPage({super.key, required this.createUserReq});

  @override
  ConsumerState<EnterPetDetailsPage> createState() =>
      _EnterPetDetailsPageState();
}

class _EnterPetDetailsPageState extends ConsumerState<EnterPetDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _petCategoryController = TextEditingController();
  final _petCategoryFocusNode = FocusNode();

  bool _isNeutered = false;
  int _petCategoryId = 0;
  File? _petProfilePicture;

  Future<void> _pickImage() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (photo != null) {
      setState(() {
        _petProfilePicture = File(photo.path);
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CreateVaccinationRecordsPage(
        createUserReq: widget.createUserReq,
        createPetReq: PetRequest(
          neutered: _isNeutered,
          name: _nameController.text,
          petCategoryId: _petCategoryId,
          petImage: _petProfilePicture,
        ),
      ),
    ));
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
        title: Text(
          AppLocalizations.of(context)!.fillPetInfo,
          style: TextStyle(
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
                  subtitle: AppLocalizations.of(context)!.enterPetDetails,
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
                        image: _petProfilePicture,
                      ),
                      TextFormField(
                        controller: _nameController,
                        key: Key("name-input"),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: AppLocalizations.of(context)!.nameLabel,
                        ),
                        validator: (value) => validateNotEmpty(context, value),
                      ),
                      TextFormField(
                        controller: _petCategoryController,
                        focusNode: _petCategoryFocusNode,
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.navigate_next,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Constants.primaryTextColor
                                    : Colors.orange,
                          ),
                          labelText:
                              AppLocalizations.of(context)!.petCategoryLabel,
                        ),
                        onTap: () async {
                          _petCategoryFocusNode.unfocus();

                          final out = await showModalBottomSheet<Lookup>(
                              context: context,
                              builder: (context) => SelectPetTypeModal());

                          if (out == null) {
                            return;
                          }
                          _petCategoryController.text = out.name;
                          _petCategoryId = out.id;
                        },
                        validator: (value) => validateNotEmpty(context, value),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.spayedNeuteredLabel,
                            ),
                            Checkbox(
                              value: _isNeutered,
                              onChanged: (value) {
                                setState(() {
                                  _isNeutered = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: Text(AppLocalizations.of(context)!.next),
                      ),
                    ],
                  ),
                ),
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: _petProfilePicture != null
                  ? DecorationImage(
                      image: FileImage(_petProfilePicture!),
                      fit: BoxFit.cover,
                    )
                  : null,
              color: Colors.grey[300],
            ),
            child: _petProfilePicture == null
                ? Icon(Icons.edit, size: 40, color: Colors.grey[700])
                : null,
          ),
          if (_petProfilePicture != null)
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
