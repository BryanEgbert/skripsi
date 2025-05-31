import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
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
  final _openingHoursController = TextEditingController();
  final _closingHoursController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _searchController = SearchController();

  String _address = "";
  double? _latitude;
  double? _longitude;
  String _locality = "";
  String? _location;
  String? _locationErrorText;
  String? _error;

  final _sessionId = Uuid().v4();
  final ILocationService _locationService =
      FirebaseRemoteConfig.instance.getBool("mock_location_service")
          ? MockLocationService()
          : LocationService();

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

    if (_latitude == null && _longitude == null && _location == null) {
      setState(() {
        _error = "Invalid location";
      });
      return;
    }

    log("latitude $_latitude, longitude: $_longitude");

    final createPetDaycareReq = CreatePetDaycareRequest(
      petDaycareName: _nameController.text,
      address: _address,
      location: _searchController.text,
      description: _descriptionController.text,
      openingHour: _openingHoursController.text,
      closingHour: _closingHoursController.text,
      locality: _locality,
      latitude: _latitude!,
      longitude: _longitude!,
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
    if (_error != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        var snackbar = SnackBar(
          key: Key("error-message"),
          content: Text(
            _error!,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red[800],
        );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);

        _error = null;
      });
    }
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
                      _locationInput(),
                      _operationHoursInput(context),
                      TextFormField(
                        controller: _descriptionController,
                        key: Key("description-input"),
                        maxLines: 6,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: "Description (optional)",
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

  Widget _operationHoursInput(BuildContext context) {
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
                readOnly: true,
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
                readOnly: true,
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

  Widget _locationInput() {
    return SearchAnchor(
      searchController: _searchController,
      builder: (context, controller) {
        return TextFormField(
          controller: controller,
          validator: (value) => validateNotEmpty("Value", value),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            labelText: "Location name",
            labelStyle: TextStyle(fontSize: 12),
          ),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          onTapOutside: (_) {
            // controller.closeView(controller.text);
          },
        );
      },
      suggestionsBuilder: (context, controller) async {
        if (controller.text.isEmpty) return [];
        final res = await _locationService.getSuggestedLocation(
            _sessionId, controller.text);

        switch (res) {
          case Ok<SuggestResponse>():
            return res.value!.suggestions.map(
              (e) => ListTile(
                onTap: () async {
                  final retrieve = await _locationService
                      .retrieveSuggestedLocation(_sessionId, e.mapboxId);
                  switch (retrieve) {
                    case Ok<RetrieveResponse>():
                      setState(() {
                        _address = retrieve
                                .value!.features[0].properties.fullAddress ??
                            retrieve.value!.features[0].properties.address ??
                            "";
                        _searchController.text =
                            retrieve.value!.features[0].properties.name;
                        _latitude = retrieve
                            .value!.features[0].properties.coordinates.latitude;
                        _longitude = retrieve.value!.features[0].properties
                            .coordinates.longitude;
                        _locality = retrieve.value!.features[0].properties
                            .context.locality!.name;
                      });
                      controller.closeView(_searchController.text);
                    case Error<RetrieveResponse>():
                      var snackbar = SnackBar(
                        key: Key("error-message"),
                        content:
                            Text("Something's wrong when fetching address"),
                        backgroundColor: Colors.red[800],
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      }
                  }
                },
                title: Text(e.name),
                subtitle: Text(e.fullAddress ?? e.address ?? ""),
              ),
            );
          case Error<SuggestResponse>():
            log("[INFO] suggest location err: ${res.error}");
            return [
              Text(res.error),
            ];
        }
      },
    );
  }
}
