import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/signup_guide_text.dart';
import 'package:frontend/model/pet_category.dart';
import 'package:frontend/model/request/create_user_request.dart';
import 'package:frontend/model/request/pet_request.dart';
import 'package:frontend/pages/signup/create_vaccination_records_page.dart';
import 'package:frontend/provider/category_provider.dart';
import 'package:image_picker/image_picker.dart';

class EnterPetDetailsPage extends ConsumerStatefulWidget {
  final CreateUserRequest createUserReq;

  const EnterPetDetailsPage({super.key, required this.createUserReq});

  @override
  ConsumerState<EnterPetDetailsPage> createState() =>
      _EnterPetDetailsPageState();
}

class _EnterPetDetailsPageState extends ConsumerState<EnterPetDetailsPage> {
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
    final petCategory = ref.watch(petCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fill Pet Info"),
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
                  subtitle: "Enter your pet details to continue",
                ),
                SizedBox(height: 56),
                Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 12,
                    children: [
                      IconButton.filled(
                        key: Key("image-picker"),
                        onPressed: () {},
                        style: IconButton.styleFrom(
                          shape: CircleBorder(),
                          minimumSize: Size(100, 100),
                        ),
                        icon: Icon(
                          Icons.add_a_photo_rounded,
                          size: 32,
                        ),
                      ),
                      TextFormField(
                        controller: _nameController,
                        key: Key("name-input"),
                        // controller: _passwordEditingController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: "Name",
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) =>
                                  selectPetTypeModal(petCategory));
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Choose Your Pet's Type & Size"),
                                  if (petCategoryId != 0)
                                    Row(
                                      children: [
                                        Text(
                                          petCategory
                                              .value![petCategoryIndex].name,
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12),
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
                      ),
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
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CreateVaccinationRecordsPage(
                              createUserReq: widget.createUserReq,
                              createPetReq: PetRequest(
                                neutered: _isNeutered,
                                name: _nameController.text,
                                petCategoryId: petCategoryId,
                                petImage: _petProfilePicture,
                              ),
                            ),
                          ));
                        },
                        child: const Text("Next"),
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

  Widget selectPetTypeModal(AsyncValue<List<PetCategory>> petCategory) {
    return StatefulBuilder(
      builder: (context, setState) {
        return switch (petCategory) {
          AsyncData(:final value) => ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                return RadioListTile(
                    title: Text(value[index].name),
                    subtitle: (value[index].sizeCategory.id != 0)
                        ? Text(
                            "${value[index].sizeCategory.minWeight.toInt()} kg - ${value[index].sizeCategory.maxWeight.toInt()} kg")
                        : null,
                    value: value[index].id,
                    groupValue: petCategoryId,
                    onChanged: (int? v) {
                      setState(() {
                        petCategoryIndex = index;
                        petCategoryId = v!;
                      });
                    });
              }),
          AsyncError() => SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Center(child: const Text("Something's wrong")),
            ),
          _ => SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: const CircularProgressIndicator(),
              ),
            ),
        };
      },
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
