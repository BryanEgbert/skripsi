import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/paginated_pets_list_view.dart';
import 'package:frontend/constants.dart';

class BookSlotsPage extends ConsumerStatefulWidget {
  const BookSlotsPage({super.key});

  @override
  ConsumerState<BookSlotsPage> createState() => _BookSlotsPageState();
}

class _BookSlotsPageState extends ConsumerState<BookSlotsPage> {
  bool _usePickupService = false;
  Map<int, bool> _petIdValue = {};

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
      body: Column(
        spacing: 8,
        children: [
          Container(
            color: Constants.secondaryBackgroundColor,
            padding: EdgeInsets.all(12),
            child: Column(
              children: [],
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
                          value: _petIdValue[pet.id],
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
