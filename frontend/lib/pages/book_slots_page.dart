import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/components/paginated_pets_list_view.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/request/book_slot_request.dart';
import 'package:frontend/model/saved_address.dart';
import 'package:frontend/model/slot.dart';
import 'package:frontend/pages/add_saved_address.dart';
import 'package:frontend/pages/saved_address_page.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/slot_provider.dart';
import 'package:frontend/utils/formatter.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/validator.dart';
import 'package:intl/intl.dart';

class BookSlotsPage extends ConsumerStatefulWidget {
  final int petDaycareId;
  const BookSlotsPage(this.petDaycareId, {super.key});

  @override
  ConsumerState<BookSlotsPage> createState() => _BookSlotsPageState();
}

class _BookSlotsPageState extends ConsumerState<BookSlotsPage> {
  final _formKey = GlobalKey<FormState>();

  final _dateRangeController = TextEditingController();

  String? _startDate;
  String? _endDate;

  List<Slot> _availableDates = [];

  final Map<int, bool> _petIdValue = {};
  final List<int> _petCategoryIds = [];

  bool _usePickupService = false;

  SavedAddress? _savedAddress;
  int addressId = 0;
  String? _locationErrorText;

  void _submitForm() {
    if (_petIdValue.keys.isEmpty) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    log("petID: ${_petIdValue.keys.toList()}");

    var request = BookSlotRequest(
      petId: _petIdValue.keys.toList(),
      startDate: _startDate!,
      endDate: _endDate!,
      usePickupService: _usePickupService,
      addressId: _savedAddress == null ? 0 : _savedAddress!.id,
    );

    log("[BOOK SLOTS PAGE] petId: ${request.petId}");

    ref.read(slotStateProvider.notifier).bookSlot(widget.petDaycareId, request);
  }

  @override
  Widget build(BuildContext context) {
    final savedAddress = ref.watch(savedAddressProvider());
    final slotState = ref.watch(slotStateProvider);

    log("use pickup: $_usePickupService");

    handleValue(slotState, this, ref.read(slotStateProvider.notifier).reset);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            "Book Slots",
            style: TextStyle(color: Colors.orange),
          ),
        ),
        body: switch (savedAddress) {
          AsyncError(:final error) => ErrorText(
              errorText: error.toString(),
              onRefresh: () => ref.refresh(savedAddressProvider().future)),
          AsyncData(:final value) => SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  Container(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Constants.secondaryBackgroundColor
                        : null,
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _usePickupService,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _usePickupService = value;
                                ref.invalidate(slotStateProvider);
                              });
                            }
                          },
                          title: Text("Use Pick-Up Service"),
                        ),
                        AbsorbPointer(
                          absorbing: !_usePickupService,
                          child: InkWell(
                            onTap: () async {
                              if (value.data.isNotEmpty) {
                                final pickedAddress =
                                    await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                  builder: (context) => SavedAddressPage(
                                    selected: 1,
                                  ),
                                )) as SavedAddress;

                                _savedAddress = pickedAddress;
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AddSavedAddress(),
                                ));
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Row(
                                spacing: 12,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: _usePickupService
                                        ? Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Constants.primaryTextColor
                                            : Colors.orange
                                        : Colors.grey[700],
                                  ),
                                  if (value.data.isEmpty)
                                    Text(
                                      "Choose an address",
                                      style: TextStyle(
                                        color: _usePickupService
                                            ? Theme.of(context).brightness ==
                                                    Brightness.light
                                                ? Constants.primaryTextColor
                                                : Colors.orange
                                            : Colors.grey[700],
                                      ),
                                    )
                                  else
                                    Text(
                                      value.data[0].name,
                                      style: TextStyle(
                                        color: _usePickupService
                                            ? Theme.of(context).brightness ==
                                                    Brightness.light
                                                ? Constants.primaryTextColor
                                                : Colors.orange
                                            : Colors.grey[700],
                                      ),
                                    ),
                                  Icon(
                                    Icons.navigate_next_rounded,
                                    color: _usePickupService
                                        ? Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Constants.primaryTextColor
                                            : Colors.orange
                                        : Colors.grey[700],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.secondaryBackgroundColor
                          : null,
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
                                        ref.invalidate(slotStateProvider);

                                        if (value) {
                                          _petCategoryIds
                                              .add(pet.petCategory.id);
                                        } else {
                                          _petCategoryIds
                                              .remove(pet.petCategory.id);
                                        }
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
                  Container(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Constants.secondaryBackgroundColor
                        : null,
                    padding: EdgeInsets.all(12),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Choose Booking Date",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            enabled: _petIdValue.values.contains(true),
                            readOnly: true,
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white70,
                            ),
                            controller: _dateRangeController,
                            onTap: () async {
                              final slotDate = ref.read(getSlotsProvider(
                                widget.petDaycareId,
                                _petCategoryIds.toSet().toList(),
                              ));

                              final dateRange = await showDateRangePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                lastDate:
                                    DateTime.now().add(Duration(days: 365)),
                                selectableDayPredicate:
                                    (day, selectedStartDay, selectedEndDay) {
                                  log("slotDate: $slotDate");
                                  if (slotDate.hasValue) {
                                    log("slot date has value");
                                    return !slotDate.value!.data.any(
                                      (element) {
                                        if (element.slotAmount <= 0) {
                                          DateTime disabledDate =
                                              DateTime.parse(element.date)
                                                  .toLocal();
                                          log("disabled: ${disabledDate.toString()}");
                                          return disabledDate.year ==
                                                  day.year &&
                                              disabledDate.month == day.month &&
                                              disabledDate.day == day.day;
                                        }

                                        return true;
                                      },
                                    );
                                  }

                                  return true;
                                },
                                builder: (context, child) {
                                  final isDark = Theme.of(context).brightness ==
                                      Brightness.dark;

                                  return Theme(
                                    data: isDark
                                        ? ThemeData.dark().copyWith(
                                            colorScheme: ColorScheme.dark(
                                              primary: Colors.orange,
                                              onSurface: Colors.white70,
                                            ),
                                            dialogBackgroundColor:
                                                Colors.grey[900],
                                            textTheme:
                                                ThemeData.dark().textTheme,
                                          )
                                        : Theme.of(context),
                                    child: child!,
                                  );
                                },
                              );

                              if (dateRange == null) return;

                              setState(() {
                                _startDate =
                                    toRfc3339WithOffset(dateRange.start);
                                _endDate = toRfc3339WithOffset(dateRange.end);
                                _dateRangeController.text =
                                    "${formatDate(dateRange.start)} - ${formatDate(dateRange.end)}";
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              labelText: "Booking Date",
                            ),
                            validator: (value) =>
                                validateNotEmpty("Input", value),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: ElevatedButton(
                      onPressed: () {
                        if (slotState.isLoading) return;

                        if (value.data.isNotEmpty) {
                          _savedAddress ??= value.data[0];
                        }

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
                ],
              ),
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
