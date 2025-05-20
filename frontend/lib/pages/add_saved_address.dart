import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/request/create_saved_address_request.dart';
import 'package:frontend/model/response/mapbox/retrieve_response.dart';
import 'package:frontend/model/response/mapbox/suggest_response.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/saved_address_provider.dart';
import 'package:frontend/services/location_service.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/validator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

class AddSavedAddress extends ConsumerStatefulWidget {
  const AddSavedAddress({super.key});

  @override
  ConsumerState<AddSavedAddress> createState() => _AddSavedAddressState();
}

class _AddSavedAddressState extends ConsumerState<AddSavedAddress> {
  final _formKey = GlobalKey<FormState>();
  final _sessionId = Uuid().v4();

  final _notesController = TextEditingController();
  final _addressController = TextEditingController();

  final _searchController = SearchController();
  // TODO: change this on release
  final _locationService = MockLocationService();

  double _latitude = 0.0;
  double _longitude = 0.0;

  bool _serviceEnabled = false;

  Future<void> _getLocationService() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
  }

  // TODO: Function won't run if _notesController is empty
  void _submitForm() {
    if (ref.read(savedAddressStateProvider).isLoading) return;
    if (!_formKey.currentState!.validate()) return;
    ref.read(savedAddressStateProvider.notifier).addSavedAddress(
          CreateSavedAddressRequest(
            name: _searchController.text,
            address: _addressController.text,
            latitude: _latitude,
            longitude: _longitude,
            notes:
                _notesController.text.isNotEmpty ? _notesController.text : null,
          ),
        );
  }

  @override
  void initState() {
    super.initState();
    _getLocationService();
  }

  @override
  Widget build(BuildContext context) {
    final savedAddressState = ref.watch(savedAddressStateProvider);

    handleError(savedAddressState, context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "Add Address",
          style: TextStyle(color: Constants.primaryTextColor),
        ),
        actions: appBarActions(ref.read(authProvider.notifier)),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () async {
                    var permission = await Geolocator.checkPermission();
                    if (permission == LocationPermission.denied) {
                      permission = await Geolocator.requestPermission();
                      if (permission == LocationPermission.denied) {
                        var snackbar = SnackBar(
                          key: Key("error-message"),
                          content: Text(
                            "Location request denied.",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red[800],
                        );

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        }
                      }
                    }

                    final serviceEnabled =
                        await Geolocator.isLocationServiceEnabled();

                    if (!serviceEnabled) {
                      await Geolocator.openLocationSettings();
                    }

                    final position = await Geolocator.getCurrentPosition();

                    _latitude = position.latitude;
                    _longitude = position.longitude;

                    final res = await _locationService.reverseLookup(
                        _latitude, _longitude);
                    switch (res) {
                      case Ok():
                        final prop = res.value!.features[0].properties;
                        setState(() {
                          _searchController.text = prop.name;
                          _addressController.text =
                              prop.fullAddress ?? prop.address ?? "";
                        });

                        break;
                      case Error():
                        var snackbar = SnackBar(
                          key: Key("error-message"),
                          content: Text(
                            res.error,
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red[800],
                        );

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        }
                    }
                  },
                  child: Row(
                    spacing: 8,
                    children: [
                      (_serviceEnabled)
                          ? Icon(Icons.gps_fixed_rounded)
                          : Icon(Icons.gps_not_fixed_rounded),
                      Text("Use Current Location"),
                    ],
                  ),
                ),
                Divider(),
                SearchAnchor(
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
                        controller.closeView(controller.text);
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
                                  .retrieveSuggestedLocation(
                                      _sessionId, e.mapboxId);
                              switch (retrieve) {
                                case Ok<RetrieveResponse>():
                                  setState(() {
                                    _addressController.text = retrieve
                                            .value!
                                            .features[0]
                                            .properties
                                            .fullAddress ??
                                        retrieve.value!.features[0].properties
                                            .address ??
                                        "";
                                    _searchController.text = retrieve
                                        .value!.features[0].properties.name;
                                    _latitude = retrieve.value!.features[0]
                                        .properties.coordinates.latitude;
                                    _longitude = retrieve.value!.features[0]
                                        .properties.coordinates.longitude;
                                  });
                                  controller.closeView(_searchController.text);
                                case Error<RetrieveResponse>():
                                  var snackbar = SnackBar(
                                    key: Key("error-message"),
                                    content: Text(
                                        "Something's wrong when fetching address"),
                                    backgroundColor: Colors.red[800],
                                  );

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);
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
                ),
                TextFormField(
                  controller: _addressController,
                  validator: (value) => validateNotEmpty("Value", value),
                  maxLines: 6,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: "Address",
                    labelStyle: TextStyle(fontSize: 12),
                  ),
                ),
                TextFormField(
                  controller: _notesController,
                  key: Key("notes-input"),
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: "Notes (optional)",
                    helperText:
                        "e.g. Black front door, White wall with 2 plants",
                    labelStyle: TextStyle(fontSize: 12),
                  ),
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: (!savedAddressState.isLoading)
                      ? Text(
                          "Add Address",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
