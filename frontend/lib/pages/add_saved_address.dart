import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/request/create_saved_address_request.dart';
import 'package:frontend/model/response/mapbox/retrieve_response.dart';
import 'package:frontend/model/response/mapbox/suggest_response.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/saved_address_provider.dart';
import 'package:frontend/services/location_service.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:uuid/uuid.dart';

class AddSavedAddress extends ConsumerStatefulWidget {
  const AddSavedAddress({super.key});

  @override
  ConsumerState<AddSavedAddress> createState() => _AddSavedAddressState();
}

class _AddSavedAddressState extends ConsumerState<AddSavedAddress> {
  final _sessionId = Uuid().v4();
  final _notesController = TextEditingController();
  // TODO: change this on release
  final _locationService = MockLocationService();

  String _address = "";
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _location = "";

  void _submitForm() {
    ref.read(savedAddressStateProvider.notifier).addSavedAddress(
          CreateSavedAddressRequest(
            name: _location,
            address: _address,
            latitude: _latitude,
            longitude: _longitude,
          ),
        );
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
        actions: appBarActions(ref.read(authProvider.notifier)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TODO: change icon if gps is turned on, get coordinate data using geolocator
          Row(
            children: [
              Icon(Icons.gps_not_fixed),
              Text("Use current location"),
            ],
          ),
          SearchAnchor(
            builder: (context, controller) {
              return TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: "Address",
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
                            _address = retrieve.value!.features[0].properties
                                    .fullAddress ??
                                retrieve.value!.features[0].properties.address!;
                            _location =
                                retrieve.value!.features[0].properties.name;
                            _latitude = retrieve.value!.features[0].properties
                                .coordinates.latitude;
                            _longitude = retrieve.value!.features[0].properties
                                .coordinates.longitude;
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
                      subtitle: Text(e.fullAddress ?? e.address!),
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
          TextField(
            controller: _notesController,
            key: Key("notes-input"),
            maxLines: 6,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              labelText:
                  "Notes e.g. Black front door, White wall with 2 plants. (optional)",
            ),
          ),
          ElevatedButton(
              onPressed: _submitForm,
              child: Text(
                "Submit",
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
