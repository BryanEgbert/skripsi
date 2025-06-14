import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/request/vaccination_record_request.dart';
import 'package:frontend/model/vaccine_record.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/vaccination_record_provider.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/handle_provider.dart';
import 'package:frontend/utils/validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditVaccinationRecordPage extends ConsumerStatefulWidget {
  final int vaccinationRecordId;
  final int petId;
  const EditVaccinationRecordPage(this.vaccinationRecordId, this.petId,
      {super.key});

  @override
  ConsumerState<EditVaccinationRecordPage> createState() =>
      _EditVaccinationRecordPageState();
}

class _EditVaccinationRecordPageState
    extends ConsumerState<EditVaccinationRecordPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateAdministeredController = TextEditingController();
  final _nextDueDateController = TextEditingController();

  File? _vaccinationPhoto;
  bool _isDateAdministeredFilled = true;
  DateTime _dateAdministered = DateTime.now();
  DateTime _nextDueDate = DateTime.now();
  bool _hasLoaded = false;
  String? _vaccinationRecordImageUrl;

  String? _imageError;

  Future<void> _pickImage() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (photo != null) {
      setState(() {
        _vaccinationPhoto = File(photo.path);
      });
    }
  }

  void _submitForm() async {
    if (_vaccinationPhoto == null && _vaccinationRecordImageUrl == null) {
      setState(() {
        _imageError = AppLocalizations.of(context)!.imageRequired;
      });
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final req = VaccinationRecordRequest(
      vaccineRecordImage: _vaccinationPhoto,
      dateAdministered: _dateAdministeredController.text,
      nextDueDate: _nextDueDateController.text,
    );
    ref
        .read(vaccinationRecordStateProvider.notifier)
        .updateRecord(widget.petId, widget.vaccinationRecordId, req);
  }

  @override
  Widget build(BuildContext context) {
    final record =
        ref.watch(getVaccinationRecordByIdProvider(widget.vaccinationRecordId));
    final recordState = ref.watch(vaccinationRecordStateProvider);

    handleError(recordState, context,
        ref.read(vaccinationRecordStateProvider.notifier).reset);

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

    if (recordState.hasValue && !recordState.isLoading) {
      if (recordState.value == 204) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pop();
        });
      }
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
        title: Text(
          AppLocalizations.of(context)!.editVaccinationRecord,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Constants.primaryTextColor
                : Colors.orange,
          ),
        ),
      ),
      body: handleProvider<VaccineRecord>(
        record,
        () => ref.refresh(
            getVaccinationRecordByIdProvider(widget.vaccinationRecordId)
                .future),
        (value) => _buildBody(context, value),
      ),
    );
  }

  Widget _buildBody(BuildContext context, VaccineRecord value) {
    Locale locale = Localizations.localeOf(context);
    DateTime parsedDateAdministered =
        DateTime.parse(value.dateAdministered).toLocal();
    DateTime parsedNextDueDate = DateTime.parse(value.nextDueDate).toLocal();
    if (!_hasLoaded) {
      _vaccinationRecordImageUrl = value.imageUrl;
      _dateAdministered = parsedDateAdministered;

      _dateAdministeredController.text =
          DateFormat('yyyy-MM-dd', locale.toLanguageTag())
              .format(parsedDateAdministered);

      _nextDueDateController.text =
          DateFormat('yyyy-MM-dd', locale.toLanguageTag())
              .format(parsedNextDueDate);

      _hasLoaded = true;
    }

    return Center(
        child: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _vaccineRecordImagePicker(),
              TextFormField(
                readOnly: true,
                controller: _dateAdministeredController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: AppLocalizations.of(context)!.dateAdministered,
                  icon: Icon(Icons.today_rounded),
                ),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: parsedDateAdministered,
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
                    initialDate: parsedNextDueDate,
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
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(AppLocalizations.of(context)!.saveBtn),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _vaccineRecordImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: _vaccinationPhoto == null && _vaccinationRecordImageUrl == null
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
                      AppLocalizations.of(context)!.clickToAddVaccinePhoto,
                      // softWrap: true,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueGrey),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: (_vaccinationPhoto != null)
                    ? Image.file(
                        _vaccinationPhoto!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        _vaccinationRecordImageUrl!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.withAlpha(150),
                            child: Column(
                              spacing: 8,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  size: 32,
                                  semanticLabel: AppLocalizations.of(context)!
                                      .failToLoadImage,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.failToLoadImage,
                                  style: TextStyle(
                                    fontSize: 12,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
    );
  }
}
