import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/components/paginated_pets_list_view.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/pet_daycare.dart';
import 'package:frontend/model/request/book_slot_request.dart';
import 'package:frontend/model/saved_address.dart';
import 'package:frontend/pages/add_saved_address.dart';
import 'package:frontend/pages/saved_address_page.dart';
import 'package:frontend/provider/last_selected.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/slot_provider.dart';
import 'package:frontend/utils/formatter.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/validator.dart';

class BookSlotsPage extends ConsumerStatefulWidget {
  // final int petDaycareId;
  final PetDaycareDetails petDaycare;
  const BookSlotsPage(this.petDaycare, {super.key});

  @override
  ConsumerState<BookSlotsPage> createState() => _BookSlotsPageState();
}

class _BookSlotsPageState extends ConsumerState<BookSlotsPage> {
  final _formKey = GlobalKey<FormState>();

  final _dateRangeController = TextEditingController();

  String? _startDate;
  String? _endDate;

  final Map<int, bool> _petIdValue = {};
  final List<int> _petCategoryIds = [];

  bool _usePickupService = false;

  SavedAddress? _savedAddress;
  // int _addressIndex = 0;
  int addressId = 0;

  void _submitForm() {
    if (_petIdValue.keys.isEmpty) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }
    _petIdValue.removeWhere((key, value) => value == false);

    var request = BookSlotRequest(
      petId: _petIdValue.keys.toList(),
      startDate: _startDate!,
      endDate: _endDate!,
      usePickupService: _usePickupService,
      addressId: _savedAddress == null ? 0 : _savedAddress!.id,
    );

    ref
        .read(slotStateProvider.notifier)
        .bookSlot(widget.petDaycare.id, request);
  }

  @override
  Widget build(BuildContext context) {
    log("[BOOK PET DAYCARE] build");
    final savedAddress = ref.watch(savedAddressProvider(1, 100));
    final slotState = ref.watch(slotStateProvider);
    final lastSelected = ref.watch(lastSelectedProvider);

    handleValue(slotState, this, ref.read(slotStateProvider.notifier).reset);

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
            "Book Slots",
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.primaryTextColor
                  : Colors.orange,
            ),
          ),
        ),
        body: switch (savedAddress) {
          AsyncError(:final error) => ErrorText(
              errorText: error.toString(),
              onRefresh: () => ref.refresh(savedAddressProvider().future)),
          AsyncData(:final value) => Builder(builder: (context) {
              return SafeArea(
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SavedAddressPage(
                                      selectedIndex: lastSelected.value!,
                                    ),
                                  )) as int;
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AddSavedAddress(),
                                  ));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
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
                                    if (value.data.isEmpty ||
                                        lastSelected.value! < 0)
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
                                        value.data[lastSelected.value!].name,
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
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Constants.primaryTextColor
                                      : Colors.orange,
                                  fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: PaginatedPetsListView(
                                pageSize: Constants.pageSize,
                                buildBody: (pet) {
                                  bool isPetVaccinated = true;
                                  String? disabledReason;

                                  if (widget.petDaycare.mustBeVaccinated) {
                                    isPetVaccinated = pet.isVaccinated;
                                  }
                                  bool isPetCategoryMatching = false;
                                  for (var price
                                      in widget.petDaycare.pricings) {
                                    if (price.petCategory.id ==
                                        pet.petCategory.id) {
                                      isPetCategoryMatching = true;
                                    }
                                  }

                                  if (!isPetVaccinated) {
                                    disabledReason =
                                        "Pet must have a valid and up-to-date vaccination record";
                                  } else if (!isPetCategoryMatching) {
                                    disabledReason =
                                        "Pet category not supported";
                                  }
                                  return CheckboxListTile(
                                    enabled: isPetVaccinated &&
                                        isPetCategoryMatching,
                                    value: _petIdValue[pet.id] ?? false,
                                    onChanged: (value) {
                                      ref
                                          .read(slotStateProvider.notifier)
                                          .reset();
                                      setState(() {
                                        if (value != null) {
                                          _petIdValue[pet.id] = value;

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
                                    subtitle: disabledReason != null
                                        ? Text(
                                            disabledReason,
                                          )
                                        : null,
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
                                final slotDate =
                                    await ref.read(getSlotsProvider(
                                  widget.petDaycare.id,
                                  _petCategoryIds.toSet().toList(),
                                ).future);

                                // if (!mounted) return;

                                final dateRange = await showDateRangePicker(
                                  context: context,
                                  helpText:
                                      "Please select the available date range",
                                  firstDate: DateTime.now(),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 365)),
                                  selectableDayPredicate:
                                      (day, selectedStartDay, selectedEndDay) {
                                    int selectedPetCount = _petIdValue.values
                                        .where((value) => value)
                                        .length;
                                    return !slotDate.data.any(
                                      (element) {
                                        if (element.slotAmount <
                                            selectedPetCount) {
                                          DateTime disabledDate =
                                              DateTime.parse(element.date)
                                                  .toLocal();
                                          return disabledDate.year ==
                                                  day.year &&
                                              disabledDate.month == day.month &&
                                              disabledDate.day == day.day;
                                        }

                                        return false;
                                      },
                                    );
                                  },
                                  builder: (context, child) {
                                    final isDark =
                                        Theme.of(context).brightness ==
                                            Brightness.dark;

                                    return Theme(
                                      data: isDark
                                          ? ThemeData.dark().copyWith(
                                              colorScheme: ColorScheme.dark(
                                                primary: Colors.orange,
                                                onSurface: Colors.white70,
                                              ),
                                              textTheme:
                                                  ThemeData.dark().textTheme,
                                              dialogTheme: DialogThemeData(
                                                  backgroundColor:
                                                      Colors.grey[900]),
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
                            _savedAddress = value.data[lastSelected.value!];
                          }

                          _submitForm();
                        },
                        child: (slotState.isLoading)
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Book Slot",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          _ => Center(
              child: CircularProgressIndicator.adaptive(),
            )
        });
  }
}
