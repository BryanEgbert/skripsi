import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/components/paginated_pets_list_view.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/request/book_slot_request.dart';
import 'package:frontend/model/saved_address.dart';
import 'package:frontend/pages/saved_address_page.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/slot_provider.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/validator.dart';

class BookSlotsPage extends ConsumerStatefulWidget {
  final int petDaycareId;
  const BookSlotsPage(this.petDaycareId, {super.key});

  @override
  ConsumerState<BookSlotsPage> createState() => _BookSlotsPageState();
}

class _BookSlotsPageState extends ConsumerState<BookSlotsPage> {
  final _formKey = GlobalKey<FormState>();

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  final Map<int, bool> _petIdValue = {};

  bool _usePickupService = false;

  String _address = "";
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _locality = "";
  String? _location;

  SavedAddress? _savedAddress;
  String? _locationErrorText;

  void _submitForm() {
    if (_petIdValue.keys.isEmpty) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    for (var petId in _petIdValue.keys) {
      ref.read(slotStateProvider.notifier).bookSlot(
          widget.petDaycareId,
          BookSlotRequest(
            petId: petId,
            startDate: _startDateController.text,
            endDate: _endDateController.text,
            usePickupService: _usePickupService,
            address: _savedAddress?.address,
            location: _savedAddress?.name,
            latitude: _savedAddress?.latitude,
            longitude: _savedAddress?.longitude,
            notes: _savedAddress?.notes,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedAddress = ref.watch(savedAddressProvider());
    final slotState = ref.watch(slotStateProvider);

    handleError(slotState, context);

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
            onPressed: () {
              if (slotState.isLoading) return;

              _submitForm();
            },
            child: (slotState.isLoading)
                ? CircularProgressIndicator()
                : Text(
                    "Book Slot",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
        body: switch (savedAddress) {
          AsyncError(:final error) => ErrorText(
              errorText: error.toString(),
              onRefresh: () => ref.refresh(savedAddressProvider().future)),
          AsyncData(:final value) => Column(
              spacing: 8,
              children: [
                Container(
                  color: Constants.secondaryBackgroundColor,
                  padding: EdgeInsets.all(12),
                  child: Form(
                    key: _formKey,
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
                          validator: (value) =>
                              validateNotEmpty("Input", value),
                        ),
                        TextFormField(
                          controller: _endDateController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelText: "End Date",
                          ),
                          validator: (value) =>
                              validateNotEmpty("Input", value),
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
                      AbsorbPointer(
                        absorbing: !_usePickupService,
                        child: InkWell(
                          onTap: () async {
                            if (value.data.isNotEmpty) {
                              final pickedAddress = await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) => SavedAddressPage(
                                  selected: 1,
                                ),
                              )) as SavedAddress;

                              _savedAddress = pickedAddress;
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: _usePickupService
                                    ? Constants.primaryTextColor
                                    : Colors.grey[700],
                              ),
                              if (value.data.isEmpty)
                                Text(
                                  "Choose an address",
                                  style: TextStyle(
                                    color: _usePickupService
                                        ? Constants.primaryTextColor
                                        : Colors.grey[700],
                                  ),
                                )
                              else
                                Text(
                                  value.data[0].name,
                                  style: TextStyle(
                                    color: _usePickupService
                                        ? Constants.primaryTextColor
                                        : Colors.grey[700],
                                  ),
                                ),
                              SizedBox(width: double.infinity),
                              Icon(
                                Icons.navigate_next_rounded,
                                color: _usePickupService
                                    ? Constants.primaryTextColor
                                    : Colors.grey[700],
                              ),
                            ],
                          ),
                        ),
                      ),
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
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
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
                                secondary: DefaultCircleAvatar(
                                    imageUrl: pet.imageUrl ?? ""),
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
          _ => Center(
              child: CircularProgressIndicator(
                color: Constants.primaryTextColor,
              ),
            )
        });
  }

  // Widget _locationInput() {
  //   return Autocomplete<SuggestionDetailsResponse>(
  //     fieldViewBuilder:
  //         (context, textEditingController, focusNode, onFieldSubmitted) {
  //       return TextFormField(
  //         controller: textEditingController,
  //         focusNode: focusNode,
  //         onFieldSubmitted: (value) {
  //           onFieldSubmitted();
  //         },
  //         key: Key("location-input"),
  //         decoration: InputDecoration(
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           labelText: "Location",
  //           prefixIcon: Icon(Icons.location_on_outlined),
  //         ),
  //         validator: (value) => validateNotEmpty("Location", value),
  //       );
  //     },
  //     displayStringForOption: (option) => "${option.name}\n${option.address}",
  //     optionsBuilder: (textEditingValue) async {
  //       final res = await _locationService.getSuggestedLocation(
  //           _sessionId, textEditingValue.text);

  //       switch (res) {
  //         case Ok<SuggestResponse>():
  //           setState(() {
  //             _locationErrorText = null;
  //           });
  //           return res.value!.suggestions;
  //         case Error<SuggestResponse>():
  //           log("[INFO] suggest location err: ${res.error}");
  //           setState(() {
  //             _locationErrorText = "Network error, please try again";
  //           });
  //           return [];
  //       }
  //     },
  //     onSelected: (option) async {
  //       log("[INFO] mapboxId: ${option.mapboxId}");
  //       final res = await _locationService.retrieveSuggestedLocation(
  //           _sessionId, option.mapboxId);

  //       switch (res) {
  //         case Ok<RetrieveResponse>():
  //           _locality =
  //               res.value!.features[0].properties.context.locality!.name;
  //           _address = res.value!.features[0].properties.context.address!.name;
  //           _location = res.value!.features[0].properties.name;
  //           _latitude = res.value!.features[0].properties.coordinates.latitude;
  //           _longitude =
  //               res.value!.features[0].properties.coordinates.longitude;
  //           debugPrint(
  //               "[INFO] you just selected ${option.address} - $_locality - lat: $_latitude - long: $_longitude");
  //         case Error<RetrieveResponse>():
  //           setState(() {
  //             _locationErrorText =
  //                 "Something's wrong when retrieving location data";
  //           });
  //       }
  //     },
  //   );
  // }
}
