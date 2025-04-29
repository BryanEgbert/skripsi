import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/paginated_pets_list_view.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/response/mapbox/retrieve_response.dart';
import 'package:frontend/model/response/mapbox/suggest_response.dart';
import 'package:frontend/services/location_service.dart';
import 'package:frontend/utils/validator.dart';
import 'package:uuid/uuid.dart';

class BookSlotsPage extends ConsumerStatefulWidget {
  const BookSlotsPage({super.key});

  @override
  ConsumerState<BookSlotsPage> createState() => _BookSlotsPageState();
}

class _BookSlotsPageState extends ConsumerState<BookSlotsPage> {
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  final Map<int, bool> _petIdValue = {};
  final _sessionId = Uuid().v4();
  // TODO: change this on release
  final _locationService = MockLocationService();

  bool _usePickupService = false;

  String _address = "";
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _locality = "";
  String? _location;
  String? _locationErrorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.backgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "Book Slots",
          style: TextStyle(color: Colors.orange),
        ),
      ),
      bottomSheet: Container(
        color: Colors.orange,
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          // TODO: book slot logic
          onPressed: () {},
          child: Text(
            "Book Slot",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Column(
        spacing: 8,
        children: [
          Container(
            color: Constants.secondaryBackgroundColor,
            padding: EdgeInsets.all(12),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _startDateController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelText: "Start Date",
                    ),
                    validator: (value) => validateNotEmpty("Input", value),
                  ),
                  TextFormField(
                    controller: _endDateController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelText: "End Date",
                    ),
                    validator: (value) => validateNotEmpty("Input", value),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Constants.secondaryBackgroundColor,
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _usePickupService,
                      onChanged: (value) {
                        if (value != null) {
                          _usePickupService = value;
                        }
                      },
                    ),
                    Text(
                      "Use Pick-Up Service",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TextField(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Constants.secondaryBackgroundColor,
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pick Pets",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: PaginatedPetsListView(
                      pageSize: Constants.pageSize,
                      buildBody: (pet) {
                        return CheckboxListTile(
                          value: _petIdValue[pet.id] ?? false,
                          onChanged: (value) {
                            setState(() {
                              if (value != null) {
                                _petIdValue[pet.id] = value;
                              }
                            });
                          },
                          title: Text(pet.name),
                          secondary:
                              DefaultCircleAvatar(imageUrl: pet.imageUrl ?? ""),
                          subtitle: Text(
                            "Pet Category: ${pet.petCategory.name}",
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationInput() {
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
      displayStringForOption: (option) => "${option.name}\n${option.address}",
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
            _address = res.value!.features[0].properties.context.address!.name;
            _location = res.value!.features[0].properties.name;
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
