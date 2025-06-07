import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/signup_guide_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/request/create_user_request.dart';
import 'package:frontend/model/request/pet_request.dart';
import 'package:frontend/model/request/vaccination_record_request.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateVaccinationRecordsPage extends ConsumerStatefulWidget {
  final CreateUserRequest createUserReq;
  final PetRequest createPetReq;

  const CreateVaccinationRecordsPage({
    super.key,
    required this.createUserReq,
    required this.createPetReq,
  });

  @override
  ConsumerState<CreateVaccinationRecordsPage> createState() =>
      _CreateVaccinationRecordsPageState();
}

class _CreateVaccinationRecordsPageState
    extends ConsumerState<CreateVaccinationRecordsPage> {
  final _formKey = GlobalKey<FormState>();

  final _dateAdministeredController = TextEditingController();
  final _nextDueDateController = TextEditingController();

  File? _vaccinationPhoto;
  bool _isDateAdministeredFilled = false;
  DateTime _dateAdministered = DateTime.now();
  DateTime _nextDueDate = DateTime.now();
  String? _imageError;

  Future<void> _pickImage() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (photo != null) {
      setState(() {
        _vaccinationPhoto = File(photo.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = ref.watch(authProvider);
    Locale locale = Localizations.localeOf(context);

    handleError(token, context, ref.read(authProvider.notifier).reset);

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
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SignupGuideText(
                  title: AppLocalizations.of(context)!.setupAccountTitle,
                  subtitle: AppLocalizations.of(context)!
                      .addVaccinationRecordOptional,
                ),
                SizedBox(
                  height: 48,
                ),
                _vaccineRecordImagePicker(),
                Form(
                  key: _formKey,
                  child: Column(
                    spacing: 8,
                    children: [
                      TextFormField(
                        controller: _dateAdministeredController,
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
                SizedBox(height: 24),
                if (!token.isLoading)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (!token.isLoading) {
                            if (_vaccinationPhoto == null) {
                              setState(() {
                                _imageError = "Image must not be empty";
                              });
                              return;
                            }
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            VaccinationRecordRequest req =
                                VaccinationRecordRequest(
                              vaccineRecordImage: _vaccinationPhoto,
                              dateAdministered:
                                  _dateAdministeredController.text,
                              nextDueDate: _nextDueDateController.text,
                            );

                            ref.read(authProvider.notifier).createPetOwner(
                                  widget.createUserReq,
                                  widget.createPetReq,
                                  req,
                                );
                          }
                        },
                        child: !token.isLoading
                            ? Text(
                                AppLocalizations.of(context)!.createMyAccount)
                            : CircularProgressIndicator(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          if (!token.isLoading) {
                            ref.read(authProvider.notifier).createPetOwner(
                                widget.createUserReq,
                                widget.createPetReq,
                                VaccinationRecordRequest(
                                  vaccineRecordImage: null,
                                  dateAdministered: "",
                                  nextDueDate: "",
                                ));
                          }
                        },
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.skip),
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.creatingYourAccount,
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Constants.primaryTextColor
                                  : Colors.orange,
                        ),
                      ),
                      CircularProgressIndicator(),
                    ],
                  )
              ],
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
