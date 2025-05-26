import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/modals/select_pet_type_modal.dart';
import 'package:frontend/components/profile_image_picker.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/model/request/pet_request.dart';
import 'package:frontend/model/request/vaccination_record_request.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/pet_provider.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddPetPage extends ConsumerStatefulWidget {
  const AddPetPage({super.key});

  @override
  ConsumerState<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends ConsumerState<AddPetPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _petCategoryController = TextEditingController();
  final _petCategoryFocusNode = FocusNode();

  bool _isNeutered = false;
  int _petCategoryId = 0;
  File? _petProfilePicture;

  final _dateAdministeredController = TextEditingController();
  final _nextDueDateController = TextEditingController();

  File? _vaccinationPhoto;
  bool _isDateAdministeredFilled = false;
  DateTime _dateAdministered = DateTime.now();

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

    ref.read(petStateProvider.notifier).addPet(
          PetRequest(
              name: _nameController.text,
              petCategoryId: _petCategoryId,
              neutered: _isNeutered),
          VaccinationRecordRequest(
            vaccineRecordImage: _vaccinationPhoto,
            dateAdministered: _dateAdministeredController.text,
            nextDueDate: _nextDueDateController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final petState = ref.watch(petStateProvider);

    handleValue(petState, this);

    if (petState.hasValue && !petState.isLoading) {
      if (petState.value == 201) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          var snackbar = SnackBar(
            key: Key("error-message"),
            content: Text("Pet added successfully"),
            backgroundColor: Constants.successSnackbarColor,
          );

          ScaffoldMessenger.of(context).showSnackBar(snackbar);

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
        title: Text(
          "Pets",
          style: TextStyle(color: Colors.orange),
        ),
        actions: appBarActions(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 12,
                children: [
                  Text(
                    "Pet Info",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  ProfileImagePicker(
                    onTap: _pickImage,
                    image: _petProfilePicture,
                  ),
                  TextFormField(
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white70,
                    ),
                    controller: _nameController,
                    key: Key("name-input"),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelText: "Name",
                    ),
                    validator: (value) => validateNotEmpty("Name", value),
                  ),
                  TextFormField(
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white70,
                    ),
                    controller: _petCategoryController,
                    focusNode: _petCategoryFocusNode,
                    readOnly: true,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.navigate_next),
                      labelText: "Pet category",
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
                    validator: (value) =>
                        validateNotEmpty("Pet category", value),
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
                  Text(
                    "Vaccination Record (Optional)",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  _vaccineRecordImagePicker(),
                  TextFormField(
                    controller: _dateAdministeredController,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white70,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelText: "Date Administered",
                      icon: Icon(Icons.today_rounded),
                    ),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1970),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          _dateAdministered = pickedDate;
                          _isDateAdministeredFilled = true;
                          _dateAdministeredController.text = formattedDate;
                        });
                      } else {
                        _isDateAdministeredFilled = false;
                      }
                    },
                  ),
                  TextFormField(
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white70,
                    ),
                    enabled: _isDateAdministeredFilled,
                    controller: _nextDueDateController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelText: "Next Due Date",
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blueGrey),
                      ),
                      icon: Icon(Icons.today_rounded),
                    ),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        firstDate: _dateAdministered,
                        lastDate: DateTime.now().add(Duration(days: 3653)),
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          _nextDueDateController.text = formattedDate;
                        });
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text("Next"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _vaccineRecordImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: _vaccinationPhoto == null
          ? Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, color: Colors.grey),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "Click to add photo of the vaccination record",
                      // softWrap: true,
                    ),
                  ),
                ],
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                _vaccinationPhoto!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
