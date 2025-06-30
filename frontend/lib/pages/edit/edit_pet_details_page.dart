import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/components/modals/select_pet_type_modal.dart';
import 'package:frontend/components/profile_image_picker.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/model/pet.dart';
import 'package:frontend/model/request/pet_request.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/pet_provider.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/validator.dart';
import 'package:image_picker/image_picker.dart';

class EditPetDetailsPage extends ConsumerStatefulWidget {
  final int petId;
  const EditPetDetailsPage({super.key, required this.petId});

  @override
  ConsumerState<EditPetDetailsPage> createState() => _EditPetDetailsPage();
}

class _EditPetDetailsPage extends ConsumerState<EditPetDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _petCategoryController = TextEditingController();
  final _petCategoryFocusNode = FocusNode();

  bool _isNeutered = false;
  int _petCategoryId = 0;
  File? _petProfilePicture;

  bool _isLoaded = false;

  Future<void> _pickImage() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (photo != null) {
      setState(() {
        _petProfilePicture = File(photo.path);
      });
    }
  }

  void _initInitialData(Pet? value) {
    if (!_isLoaded) {
      _nameController.text = value!.name;
      _isNeutered = value.neutered;
      _petCategoryId = value.petCategory.id;
      _petCategoryController.text = value.petCategory.name;
      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pet = ref.watch(getPetByIdProvider(widget.petId));
    final petState = ref.watch(petStateProvider);

    handleValue(petState, this, ref.read(petStateProvider.notifier).reset);

    // if (petState.hasValue && !petState.isLoading) {
    //   if (petState.value == 204) {
    //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //       var snackbar = SnackBar(
    //         key: Key("success-message"),
    //         content: Text("Pet edited successfully"),
    //         backgroundColor: Colors.green[800],
    //       );

    //       ScaffoldMessenger.of(context).showSnackBar(snackbar);
    //       Navigator.of(context).pop();
    //     });
    //   }
    // }

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
          AppLocalizations.of(context)!.editPetInfoTitle,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Constants.primaryTextColor
                : Colors.orange,
          ),
        ),
      ),
      body: switch (pet) {
        AsyncError(:final error) => ErrorText(
            errorText: error.toString(),
            onRefresh: () => ref.refresh(petStateProvider.future),
          ),
        AsyncData(:final value) => Builder(builder: (context) {
            _initInitialData(value);

            return SafeArea(
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
                        image: _petProfilePicture,
                        imageUrl: value?.imageUrl,
                      ),
                      TextFormField(
                        controller: _nameController,
                        key: Key("name-input"),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: AppLocalizations.of(context)!.nameLabel,
                          hintText: value?.name,
                          hintStyle: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white70,
                          ),
                        ),
                        validator: (value) => validateNotEmpty(context, value),
                      ),
                      TextFormField(
                        controller: _petCategoryController,
                        focusNode: _petCategoryFocusNode,
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.navigate_next),
                          labelText:
                              AppLocalizations.of(context)!.petCategoryLabel,
                        ),
                        onTap: () async {
                          _petCategoryFocusNode.unfocus();

                          final out = await showModalBottomSheet<Lookup>(
                            context: context,
                            builder: (context) => SelectPetTypeModal(),
                          );

                          if (out == null) return;

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
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white70,
                              ),
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
                        onPressed: () {
                          if (petState.isLoading) return;

                          if (!_formKey.currentState!.validate()) return;

                          ref.read(petStateProvider.notifier).editPet(
                                widget.petId,
                                PetRequest(
                                  name: _nameController.text,
                                  petCategoryId: _petCategoryId,
                                  neutered: _isNeutered,
                                  petImage: _petProfilePicture,
                                  // status: value?.status,
                                ),
                              );
                        },
                        child: petState.isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(AppLocalizations.of(context)!.saveBtn),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        _ => Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          ),
      },
    );
  }
}
