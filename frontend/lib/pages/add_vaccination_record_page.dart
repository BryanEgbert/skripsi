import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/request/vaccination_record_request.dart';
import 'package:frontend/provider/vaccination_record_provider.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddVaccinationRecordPage extends ConsumerStatefulWidget {
  final int petId;
  const AddVaccinationRecordPage(this.petId, {super.key});

  @override
  ConsumerState<AddVaccinationRecordPage> createState() =>
      _AddVaccinationRecordPageState();
}

class _AddVaccinationRecordPageState
    extends ConsumerState<AddVaccinationRecordPage> {
  final _formKey = GlobalKey<FormState>();

  final _dateAdministeredController = TextEditingController();
  final _nextDueDateController = TextEditingController();

  File? _vaccinationPhoto;
  bool _isDateAdministeredFilled = false;
  DateTime _dateAdministered = DateTime.now();
  String? _imageError;

  Future<void> _pickImage() async {
    final photo = await ImagePicker().pickImage(
        source: ImageSource.gallery, preferredCameraDevice: CameraDevice.rear);

    if (photo != null) {
      setState(() {
        _vaccinationPhoto = File(photo.path);
      });
    }
  }

  void _submitForm() {
    if (_vaccinationPhoto == null) {
      setState(() {
        _imageError = "Image required";
      });
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    VaccinationRecordRequest req = VaccinationRecordRequest(
      vaccineRecordImage: _vaccinationPhoto,
      dateAdministered: _dateAdministeredController.text,
      nextDueDate: _nextDueDateController.text,
    );

    ref.read(vaccinationRecordStateProvider.notifier).create(widget.petId, req);
  }

  @override
  Widget build(BuildContext context) {
    final vaccinationRecordState = ref.watch(vaccinationRecordStateProvider);

    handleValue(vaccinationRecordState, this);

    if (vaccinationRecordState.hasValue &&
        !vaccinationRecordState.hasError &&
        !vaccinationRecordState.isLoading) {
      if (vaccinationRecordState.value == 201) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pop();
        });
      }
    }

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
            icon: Icon(Icons.arrow_back_ios)),
        title: Text(
          "Add Vaccination Record",
          style: TextStyle(color: Colors.orange),
        ),
      ),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                        validator: (value) => validateNotEmpty("value", value),
                      ),
                      TextFormField(
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
                        validator: (value) => validateNotEmpty("value", value),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: (!vaccinationRecordState.isLoading)
                      ? const Text("Add Vaccination Record")
                      : CircularProgressIndicator(
                          color: Colors.white,
                        ),
                ),
              ],
            ),
          ),
        ),
      )),
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
                    color: (_imageError == null) ? Colors.grey : Colors.red),
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
