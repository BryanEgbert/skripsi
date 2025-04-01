import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/signup_guide_text.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/request/create_pet_daycare_request.dart';
import 'package:frontend/model/request/create_user_request.dart';
import 'package:frontend/model/response/mapbox/retrieve_response.dart';
import 'package:frontend/model/response/mapbox/suggest_response.dart';
import 'package:frontend/pages/signup/add_pet_daycare_thumbnails.dart';
import 'package:frontend/services/location_service.dart';
import 'package:frontend/utils/validator.dart';
import 'package:uuid/uuid.dart';

class CreatePetDaycarePage extends ConsumerStatefulWidget {
  final CreateUserRequest createUserReq;
  const CreatePetDaycarePage({super.key, required this.createUserReq});

  @override
  ConsumerState<CreatePetDaycarePage> createState() =>
      CreatePetDaycarePageState();
}

class CreatePetDaycarePageState extends ConsumerState<CreatePetDaycarePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _openingHoursController = TextEditingController();
  final _closingHoursController = TextEditingController();
  final _descriptionController = TextEditingController();

  double _latitude = 0.0;
  double _longitude = 0.0;
  String _locality = "";
  String? _locationErrorText;

  final _sessionId = Uuid().v4();
  // TODO: change this on release
  final _locationService = MockLocationService();

  String _addLeadingZeroIfNeeded(int value) {
    if (value < 10) {
      return '0$value';
    }
    return value.toString();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final createPetDaycareReq = CreatePetDaycareRequest(
      petDaycareName: _nameController.text,
      address: _addressController.text,
      description: _descriptionController.text,
      locality: _locality,
      latitude: _latitude,
      longitude: _longitude,
      price: [],
      pricingType: [],
      hasPickupService: false,
      mustBeVaccinated: false,
      groomingAvailable: false,
      foodProvided: false,
      dailyWalksId: 0,
      dailyPlaytimeId: 0,
      thumbnails: [],
      petCategoryId: [],
      maxNumber: [],
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddPetDaycareThumbnails(
          createUserReq: widget.createUserReq,
          createPetDaycareReq: createPetDaycareReq,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SignupGuideText(
                  title: "Let's Set Up Your Account",
                  subtitle: "Enter your pet daycare details to continue",
                ),
                SizedBox(height: 56),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 12,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        key: Key("name-input"),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: "Pet Daycare Name",
                          errorText: _locationErrorText,
                        ),
                        validator: (value) => validateNotEmpty("Name", value),
                      ),
                      locationInput(),
                      operationHoursInput(context),
                      TextFormField(
                        controller: _descriptionController,
                        key: Key("description-input"),
                        maxLines: 6,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: "Description",
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text("Next"),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget operationHoursInput(BuildContext context) {
    // TODO: add validation to closing hour
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Operating Hours",
          style: TextStyle(color: Colors.orange),
        ),
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: TextFormField(
                controller: _openingHoursController,
                decoration: InputDecoration(
                  labelText: "Opening Hour",
                  labelStyle: TextStyle(fontSize: 12),
                  suffixIcon: Icon(
                    Icons.navigate_next,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
                validator: (value) => validateNotEmpty("Opening hour", value),
                onTap: () async {
                  final timeDisplay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (timeDisplay != null) {
                    setState(() {
                      _openingHoursController.text =
                          "${_addLeadingZeroIfNeeded(timeDisplay.hour)}:${_addLeadingZeroIfNeeded(timeDisplay.minute)}";
                    });
                  }
                },
              ),
            ),
            Text("to"),
            Expanded(
              child: TextFormField(
                controller: _closingHoursController,
                decoration: InputDecoration(
                  labelText: "Closing Hour",
                  labelStyle: TextStyle(fontSize: 12),
                  suffixIcon: Icon(
                    Icons.navigate_next,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
                validator: (value) => validateNotEmpty("Closing hour", value),
                onTap: () async {
                  final timeDisplay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (timeDisplay != null) {
                    setState(() {
                      _closingHoursController.text =
                          "${_addLeadingZeroIfNeeded(timeDisplay.hour)}:${_addLeadingZeroIfNeeded(timeDisplay.minute)}";
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget locationInput() {
    return Autocomplete<SuggestionDetailsResponse>(
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          onFieldSubmitted: (value) {
            onFieldSubmitted();
          },
          key: Key("location-input"),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            labelText: "Location",
            prefixIcon: Icon(Icons.location_on_outlined),
          ),
          validator: (value) => validateNotEmpty("Location", value),
        );
      },
      displayStringForOption: (option) => option.name,
      optionsBuilder: (textEditingValue) async {
        final res = await _locationService.getSuggestedLocation(
            _sessionId, textEditingValue.text);

        switch (res) {
          case Ok<SuggestResponse>():
            setState(() {
              _locationErrorText = null;
            });
            return res.value!.suggestions;
          case Error<SuggestResponse>():
            log("[INFO] suggest location err: ${res.error}");
            setState(() {
              _locationErrorText = "Network error, please try again";
            });
            return [];
        }
      },
      onSelected: (option) async {
        log("[INFO] mapboxId: ${option.mapboxId}");
        final res = await _locationService.retrieveSuggestedLocation(
            _sessionId, option.mapboxId);

        switch (res) {
          case Ok<RetrieveResponse>():
            _locality =
                res.value!.features[0].properties.context.locality!.name;
            _latitude = res.value!.features[0].properties.coordinates.latitude;
            _longitude =
                res.value!.features[0].properties.coordinates.longitude;
            debugPrint(
                "[INFO] you just selected ${option.address} - $_locality - lat: $_latitude - long: $_longitude");
          case Error<RetrieveResponse>():
            setState(() {
              _locationErrorText =
                  "Something's wrong when retrieving location data";
            });
        }
      },
    );
  }
}
