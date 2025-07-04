import 'dart:async';
import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/request/create_saved_address_request.dart';
import 'package:frontend/model/response/mapbox/retrieve_response.dart';
import 'package:frontend/model/response/mapbox/suggest_response.dart';
import 'package:frontend/model/saved_address.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/saved_address_provider.dart';
import 'package:frontend/services/location_service.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/validator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

class EditSavedAddressPage extends ConsumerStatefulWidget {
  final int addressId;
  const EditSavedAddressPage(this.addressId, {super.key});

  @override
  ConsumerState<EditSavedAddressPage> createState() =>
      _EditSavedAddressPageState();
}

class _EditSavedAddressPageState extends ConsumerState<EditSavedAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _sessionId = Uuid().v4();

  final _notesController = TextEditingController();
  final _addressController = TextEditingController();

  final _searchController = SearchController();

  final ILocationService _locationService =
      FirebaseRemoteConfig.instance.getBool("mock_location_service")
          ? MockLocationService()
          : LocationService();

  double _latitude = 0.0;
  double _longitude = 0.0;

  bool _hasLoaded = false;

  bool _serviceEnabled = false;
  LocationPermission _permission = LocationPermission.denied;

  Future<void> _getLocationService() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
  }

  void _submitForm() {
    if (ref.read(savedAddressStateProvider).isLoading) return;
    if (!_formKey.currentState!.validate()) return;
    ref.read(savedAddressStateProvider.notifier).editSavedAddress(
          widget.addressId,
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

  void _loadInitialValue(SavedAddress value) {
    _searchController.text = value.name;
    _addressController.text = value.address;
    _latitude = value.latitude;
    _longitude = value.longitude;

    if (value.notes != null) {
      _notesController.text = value.notes!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedAddress = ref.watch(savedAddressByIdProvider(widget.addressId));
    final savedAddressState = ref.watch(savedAddressStateProvider);

    handleValue(savedAddressState, this,
        ref.read(savedAddressStateProvider.notifier).reset);

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
            AppLocalizations.of(context)!.editAddress,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.primaryTextColor
                  : Colors.orange,
            ),
          ),
          actions: appBarActions(),
        ),
        body: switch (savedAddress) {
          AsyncError(:final error) => ErrorText(
              errorText: error.toString(),
              onRefresh: () => ref
                  .refresh(savedAddressByIdProvider(widget.addressId).future)),
          AsyncData(:final value) => Builder(builder: (context) {
              if (!_hasLoaded) {
                _loadInitialValue(value);
                _hasLoaded = true;
              }
              return SafeArea(
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
                            _permission = await Geolocator.checkPermission();

                            if (_permission == LocationPermission.denied) {
                              _permission =
                                  await Geolocator.requestPermission();
                              if (_permission == LocationPermission.denied ||
                                  _permission ==
                                      LocationPermission.deniedForever) {
                                var snackbar = SnackBar(
                                  key: Key("error-message"),
                                  content: Text(
                                    AppLocalizations.of(context)!
                                        .locationRequestDenied,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red[800],
                                );

                                if (mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackbar);
                                }
                              }
                            } else if (_permission ==
                                LocationPermission.deniedForever) {
                              if (!await Geolocator.openAppSettings()) return;
                              if (_permission == LocationPermission.denied) {
                                _permission =
                                    await Geolocator.requestPermission();
                                if (_permission == LocationPermission.denied ||
                                    _permission ==
                                        LocationPermission.deniedForever) {
                                  var snackbar = SnackBar(
                                    key: Key("error-message"),
                                    content: Text(
                                      AppLocalizations.of(context)!
                                          .locationRequestDenied,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red[800],
                                  );

                                  if (mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);
                                  }
                                }
                              }
                            }

                            final serviceEnabled =
                                await Geolocator.isLocationServiceEnabled();

                            if (!serviceEnabled) {
                              await Geolocator.openLocationSettings();
                            }

                            final position =
                                await Geolocator.getCurrentPosition();

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
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackbar);
                                }
                            }
                          },
                          child: Row(
                            spacing: 8,
                            children: [
                              (_serviceEnabled &&
                                      (_permission ==
                                              LocationPermission.always ||
                                          _permission ==
                                              LocationPermission.whileInUse))
                                  ? Icon(Icons.gps_fixed_rounded)
                                  : Icon(Icons.gps_not_fixed_rounded),
                              Text(AppLocalizations.of(context)!
                                  .useCurrentLocation),
                            ],
                          ),
                        ),
                        Divider(),
                        SearchAnchor(
                          searchController: _searchController,
                          builder: (context, controller) {
                            return TextFormField(
                              controller: controller,
                              validator: (value) =>
                                  validateNotEmpty(context, value),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                labelText:
                                    AppLocalizations.of(context)!.location,
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
                            final res =
                                await _locationService.getSuggestedLocation(
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
                                                retrieve.value!.features[0]
                                                    .properties.address ??
                                                "";
                                            _searchController.text = retrieve
                                                .value!
                                                .features[0]
                                                .properties
                                                .name;
                                            _latitude = retrieve
                                                .value!
                                                .features[0]
                                                .properties
                                                .coordinates
                                                .latitude;
                                            _longitude = retrieve
                                                .value!
                                                .features[0]
                                                .properties
                                                .coordinates
                                                .longitude;
                                          });
                                          controller.closeView(
                                              _searchController.text);
                                        case Error<RetrieveResponse>():
                                          var snackbar = SnackBar(
                                            key: Key("error-message"),
                                            content: Text(
                                              AppLocalizations.of(context)!
                                                  .fetchAddressError,
                                            ),
                                            backgroundColor: Colors.red[800],
                                          );

                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackbar);
                                          }
                                      }
                                    },
                                    title: Text(e.name),
                                    subtitle:
                                        Text(e.fullAddress ?? e.address ?? ""),
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
                          validator: (value) =>
                              validateNotEmpty(context, value),
                          maxLines: 6,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelText: AppLocalizations.of(context)!.address,
                            labelStyle: TextStyle(fontSize: 12),
                          ),
                        ),
                        TextFormField(
                          controller: _notesController,
                          key: Key("notes-input"),
                          keyboardType: TextInputType.multiline,
                          maxLines: 6,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelText:
                                AppLocalizations.of(context)!.notesOptional,
                            helperText:
                                AppLocalizations.of(context)!.notesExample,
                            labelStyle: TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            _submitForm();
                          },
                          child: (!savedAddressState.isLoading)
                              ? Text(
                                  AppLocalizations.of(context)!
                                      .saveAddressButton,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          _ => Center(
              child: CircularProgressIndicator.adaptive(),
            ),
        });
  }
}
