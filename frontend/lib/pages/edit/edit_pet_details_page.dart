import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/components/modals/select_pet_type_modal.dart';
import 'package:frontend/components/profile_image_picker.dart';
import 'package:frontend/model/pet_category.dart';
import 'package:frontend/model/request/pet_request.dart';
import 'package:frontend/provider/category_provider.dart';
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
  final _nameController = TextEditingController();
  bool _isNeutered = false;
  int petCategoryId = 0;
  int petCategoryIndex = 0;
  File? _petProfilePicture;

  Future<void> _pickImage() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (photo != null) {
      setState(() {
        _petProfilePicture = File(photo.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pet = ref.watch(getPetByIdProvider(widget.petId));
    final petState = ref.watch(petStateProvider);

    log("[INFO] $petState");
    final petCategory = ref.watch(petCategoryProvider);
    handleError(petState, context);

    if (petState.hasValue && !petState.isLoading) {
      if (petState.value == 204) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pop();
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          "Edit Pet Info",
          style: TextStyle(color: Colors.orange),
        ),
      ),
      body: switch (pet) {
        AsyncError(:final error) => ErrorText(
            errorText: error.toString(),
            onRefresh: () => ref.refresh(petStateProvider.future),
          ),
        AsyncData(:final value) => Builder(builder: (context) {
            _nameController.text = value!.name;
            _isNeutered = value.neutered;
            petCategoryId = value.petCategory.id;

            return SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 12,
                    children: [
                      ProfileImagePicker(
                        onTap: _pickImage,
                        image: _petProfilePicture,
                        imageUrl: value.imageUrl,
                      ),
                      TextFormField(
                        controller: _nameController,
                        key: Key("name-input"),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelText: "Name",
                            hintText: value.name),
                        validator: (value) => validateNotEmpty("Name", value),
                      ),
                      // TODO: add not empty validation
                      petCategoryInput(context, petCategory),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Spayed/Neutered"),
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
                        onPressed: () async {
                          if (petState.isLoading) return;

                          await ref.read(petStateProvider.notifier).editPet(
                                widget.petId,
                                PetRequest(
                                  name: _nameController.text,
                                  petCategoryId: petCategoryId,
                                  neutered: _isNeutered,
                                  petImage: _petProfilePicture,
                                  status: value.status,
                                ),
                              );
                        },
                        child: petState.isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("Save"),
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

  Widget petCategoryInput(
      BuildContext context, AsyncValue<List<PetCategory>> petCategory) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => SelectPetTypeModal(
            petCategoryId,
            petCategory,
            (value, index) {
              setState(() {
                petCategoryIndex = index;
                petCategoryId = value!;
              });
            },
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Choose Your Pet's Type & Size"),
                if (petCategoryId != 0)
                  Row(
                    children: [
                      Text(
                        petCategory.value![petCategoryIndex].name,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                if (petCategoryId == 0)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.orange,
                  ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
