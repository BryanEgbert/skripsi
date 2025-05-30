import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/request/vaccination_record_request.dart';
import 'package:frontend/model/vaccine_record.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/vaccination_record_provider.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/handle_provider.dart';
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
  final _dateAdministeredController = TextEditingController();
  final _nextDueDateController = TextEditingController();

  File? _vaccinationPhoto;
  bool _isDateAdministeredFilled = true;
  DateTime _dateAdministered = DateTime.now();
  bool _hasLoaded = false;
  String? _vaccinationRecordImageUrl;

  Future<void> _pickImage() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (photo != null) {
      setState(() {
        _vaccinationPhoto = File(photo.path);
      });
    }
  }

  void _submitForm() async {
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

    handleValue(recordState, this);

    if (recordState.hasValue && !recordState.isLoading) {
      if (recordState.value == 204) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          var snackbar = SnackBar(
            key: Key("error-message"),
            content: Text("Vaccination record added successfully"),
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
        title: const Text(
          "Edit Vaccination Record",
          style: TextStyle(color: Colors.orange),
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
    DateTime parsedDateAdministered =
        DateTime.parse(value.dateAdministered).toLocal();
    DateTime parsedNextDueDate = DateTime.parse(value.nextDueDate).toLocal();
    if (!_hasLoaded) {
      _vaccinationRecordImageUrl = value.imageUrl;
      _dateAdministered = parsedDateAdministered;

      _dateAdministeredController.text =
          DateFormat('yyyy-MM-dd').format(parsedDateAdministered);

      _nextDueDateController.text =
          DateFormat('yyyy-MM-dd').format(parsedNextDueDate);

      _hasLoaded = true;
    }

    return Center(
        child: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _vaccineRecordImagePicker(),
            TextField(
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white70,
              ),
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
                  initialDate: parsedDateAdministered,
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
            TextField(
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
                  initialDate: parsedNextDueDate,
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
              child: const Text("Save"),
            ),
          ],
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
                      "Click to add photo of the vaccination record",
                      // softWrap: true,
                    ),
                  ),
                ],
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: (_vaccinationPhoto != null)
                  ? Image.file(
                      _vaccinationPhoto!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.network(_vaccinationRecordImageUrl!)),
    );
  }
}
