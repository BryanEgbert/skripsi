import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/modals/select_pet_type_modal.dart';
import 'package:frontend/components/profile_image_picker.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/model/request/pet_request.dart';
import 'package:frontend/model/request/vaccination_record_request.dart';
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
  final _petFormKey = GlobalKey<FormState>();
  final _vaccinationRecordFormKey = GlobalKey<FormState>();

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
  DateTime _nextDueDate = DateTime.now();

  String? _imageError;

  Future<void> _pickPetImage() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (photo != null) {
      setState(() {
        _petProfilePicture = File(photo.path);
      });
    }
  }

  Future<void> _pickVaccinationRecordImage() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (photo != null) {
      setState(() {
        _vaccinationPhoto = File(photo.path);
      });
    }
  }

  void _submitForm() {
    if (ref.read(petStateProvider).isLoading) return;
    if (!_petFormKey.currentState!.validate()) {
      return;
    }

    if (_vaccinationPhoto != null ||
        _dateAdministeredController.text.isNotEmpty ||
        _nextDueDateController.text.isNotEmpty) {
      if (_vaccinationPhoto == null) {
        setState(() {
          _imageError = AppLocalizations.of(context)!.vaccinationImageRequired;
        });
        return;
      }

      if (!_vaccinationRecordFormKey.currentState!.validate()) {
        return;
      }
    }

    ref.read(petStateProvider.notifier).addPet(
          PetRequest(
            name: _nameController.text,
            petCategoryId: _petCategoryId,
            neutered: _isNeutered,
            petImage: _petProfilePicture,
          ),
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
    Locale locale = Localizations.localeOf(context);

    handleValue(petState, this, ref.read(petStateProvider.notifier).reset);

    if (_imageError != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        var snackbar = SnackBar(
          key: Key("error-message"),
          content: Text(_imageError!),
          backgroundColor: Colors.red,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        _imageError = null;
      });
    }

    // if (petState.hasValue && !petState.isLoading) {
    //   if (petState.value == 201) {
    //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //       var snackbar = SnackBar(
    //         key: Key("error-message"),
    //         content: Text("Pet added successfully"),
    //         backgroundColor: Constants.successSnackbarColor,
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
          AppLocalizations.of(context)!.addPet,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Constants.primaryTextColor
                : Colors.orange,
          ),
        ),
        actions: appBarActions(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(
                  key: _petFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 12,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.petInfo,
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Constants.primaryTextColor
                                  : Colors.orange,
                          fontSize: 20,
                        ),
                      ),
                      ProfileImagePicker(
                        onTap: _pickPetImage,
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
                          suffixIcon: Icon(Icons.navigate_next),
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
                            Text(AppLocalizations.of(context)!
                                .spayedNeuteredLabel),
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
                    ],
                  ),
                ),
                Form(
                  key: _vaccinationRecordFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 12,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.vaccinationRecordOptional,
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Constants.primaryTextColor
                                  : Colors.orange,
                          fontSize: 20,
                        ),
                      ),
                      _vaccineRecordImagePicker(),
                      TextFormField(
                        controller: _dateAdministeredController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText:
                              AppLocalizations.of(context)!.dateAdministered,
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
                                DateFormat('yyyy-MM-dd', locale.toLanguageTag())
                                    .format(pickedDate);
                            setState(() {
                              _dateAdministered = pickedDate;
                              _isDateAdministeredFilled = true;
                              _dateAdministeredController.text = formattedDate;
                            });
                          } else {
                            _isDateAdministeredFilled = false;
                          }
                        },
                        validator: (value) => validateNotEmpty(context, value),
                      ),
                      TextFormField(
                        readOnly: true,
                        enabled: _isDateAdministeredFilled,
                        controller: _nextDueDateController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: AppLocalizations.of(context)!.nextDueDate,
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.blueGrey),
                          ),
                          icon: Icon(Icons.today_rounded),
                        ),
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            firstDate: _dateAdministered.add(Duration(days: 1)),
                            lastDate: DateTime.now().add(Duration(days: 3653)),
                          );

                          if (pickedDate != null) {
                            _nextDueDate = pickedDate;
                            String formattedDate =
                                DateFormat('yyyy-MM-dd', locale.toLanguageTag())
                                    .format(pickedDate);
                            setState(() {
                              _nextDueDateController.text = formattedDate;
                            });
                          }
                        },
                        validator: (value) => validateNextDueDate(
                            context, _dateAdministered, _nextDueDate, value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: (!ref.read(petStateProvider).isLoading)
                      ? Text(AppLocalizations.of(context)!.addPet)
                      : CircularProgressIndicator(
                          color: Colors.white,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _vaccineRecordImagePicker() {
    return GestureDetector(
      onTap: _pickVaccinationRecordImage,
      child: _vaccinationPhoto == null
          ? Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey
                      : Colors.white60,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, color: Colors.grey),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.clickToAddVaccinePhoto,
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
