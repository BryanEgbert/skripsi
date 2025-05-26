import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_back_button.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/components/modals/select_lookup_modal.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/model/pet_daycare.dart';
import 'package:frontend/model/request/update_pet_daycare_request.dart';
import 'package:frontend/model/response/mapbox/retrieve_response.dart';
import 'package:frontend/model/response/mapbox/suggest_response.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/pet_daycare_provider.dart';
import 'package:frontend/services/location_service.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class EditPetDaycarePage extends ConsumerStatefulWidget {
  final int petDaycareId;
  const EditPetDaycarePage(this.petDaycareId, {super.key});

  @override
  ConsumerState<EditPetDaycarePage> createState() => _EditPetDaycarePageState();
}

class _EditPetDaycarePageState extends ConsumerState<EditPetDaycarePage> {
  final defaultTextStyle = TextStyle(
    color: Colors.orange,
    fontWeight: FontWeight.bold,
  );

  static const _miniatureDogID = 1;
  static const _smallDogID = 2;
  static const _mediumDogID = 3;
  static const _largeDogID = 4;
  static const _giantDogID = 5;

  final _petDaycareDetailsFormKey = GlobalKey<FormState>();
  final _petDaycareSlotsFormKey = GlobalKey<FormState>();
  final _petDaycareServiceFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _openingHoursController = TextEditingController();
  final _closingHoursController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _address = "";
  double? _latitude;
  double? _longitude;
  String _locality = "";

  String? _locationErrorText;

  final List<File?> _images = List.filled(9, null);
  List<String> _imageUrls = [];
  String? _errorText;

  final _sessionId = Uuid().v4();
  // TODO: change this on release
  final _locationService = MockLocationService();

  final _miniatureDogPriceController = TextEditingController();
  final _miniatureDogPricingTypeController = TextEditingController(text: "day");
  final _miniatureDogSlotController = TextEditingController();

  final _smallDogPriceController = TextEditingController();
  final _smallDogPricingTypeController = TextEditingController(text: "day");
  final _smallDogSlotController = TextEditingController();

  final _mediumDogPriceController = TextEditingController();
  final _mediumDogPricingTypeController = TextEditingController(text: "day");
  final _mediumDogSlotController = TextEditingController();

  final _largeDogPriceController = TextEditingController();
  final _largeDogPricingTypeController = TextEditingController(text: "day");
  final _largeDogSlotController = TextEditingController();

  final _giantDogPriceController = TextEditingController();
  final _giantDogPricingTypeController = TextEditingController(text: "day");
  final _giantDogSlotController = TextEditingController();

  final _catsPriceController = TextEditingController();
  final _catsPricingTypeController = TextEditingController(text: "day");
  final _catsSlotController = TextEditingController();

  final _bunniesPriceController = TextEditingController();
  final _bunniesPricingTypeController = TextEditingController(text: "day");
  final _bunniesSlotController = TextEditingController();

  bool _acceptMiniatureDog = false;
  bool _acceptSmallDog = false;
  bool _acceptMediumDog = false;
  bool _acceptLargeDog = false;
  bool _acceptGiantDog = false;

  final List<int> _petCategoryIds = [];
  final List<double> _prices = [];
  final List<int> _pricingTypes = [];
  final List<int> _maxNumbers = [];
  final List<int> _thumbnailIndex = [];

  final List<int> _existingPetCategoryId = [];

  bool _acceptCats = false;
  bool _acceptBunnies = false;

  final _dailyWalkController = TextEditingController();
  final _dailyPlaytimeController = TextEditingController();

  final _searchController = SearchController();

  final _categoryFocusNode = FocusNode();

  bool _petVaccinationRequired = false;
  bool _groomingServiceProvided = false;
  bool _pickupServiceProvided = false;
  bool _foodProvided = false;

  int _dailyWalksId = 0;
  int _dailyPlaytimeId = 0;

  bool _isLoaded = false;

  String _addLeadingZeroIfNeeded(int value) {
    if (value < 10) {
      return '0$value';
    }
    return value.toString();
  }

  Future<void> _pickImage(int index) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (!_thumbnailIndex.contains(index + 1)) {
        _thumbnailIndex.add(index + 1);
      }

      setState(() {
        _images[index] = File(pickedFile.path);
        log("[pickImage] index: $index, file: ${pickedFile.path}");
      });
    }
  }

  void _deleteImage(int index) {
    setState(() {
      _images[index] = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    log("[EDIT PET DAYCARE PAGE] build");

    final petDaycare = ref.watch(getMyPetDaycareProvider);
    final petDaycareState = ref.watch(petDaycareStateProvider);

    log("[EDIT PET DAYCARE PAGE] petDaycareState: $petDaycareState");

    if (_errorText != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        var snackbar = SnackBar(
          key: Key("error-message"),
          content: Text(_errorText!),
          backgroundColor: Colors.red,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        _errorText = null;
      });
    }

    handleValue(petDaycareState, context,
        ref.read(petDaycareStateProvider.notifier).reset);

    // if (petDaycareState.hasValue &&
    //     !petDaycareState.hasError &&
    //     !petDaycareState.isLoading) {
    //   if (petDaycareState.value == 204) {
    //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //       Navigator.of(context).pop();
    //     });
    //   }
    // }
    return switch (petDaycare) {
      AsyncError(:final error) => Scaffold(
          appBar: AppBar(
            leading: appBarBackButton(context),
            title: Text(
              "Edit Pet Daycare",
              style: TextStyle(color: Colors.orange),
            ),
            centerTitle: false,
          ),
          body: ErrorText(
              errorText: error.toString(),
              onRefresh: () => ref.refresh(getMyPetDaycareProvider.future)),
        ),
      AsyncData(:final value) => Builder(builder: (context) {
          if (!_isLoaded) {
            _loadInitialValue(value);
            _isLoaded = true;
          }

          return DefaultTabController(
            initialIndex: 0,
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                leading: appBarBackButton(context),
                title: Text(
                  "Edit Pet Daycare",
                  style: TextStyle(color: Colors.orange),
                ),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: () {
                      if (_latitude == null && _longitude == null) {
                        setState(() {
                          _errorText = "Invalid location";
                        });
                        return;
                      }
                      if (_petDaycareDetailsFormKey.currentState != null) {
                        if (!_petDaycareDetailsFormKey.currentState!
                            .validate()) {
                          return;
                        }
                      }

                      if (_petDaycareSlotsFormKey.currentState != null) {
                        if (!_petDaycareSlotsFormKey.currentState!.validate()) {
                          return;
                        }
                      }

                      if (_petDaycareServiceFormKey.currentState != null) {
                        if (!_petDaycareServiceFormKey.currentState!
                            .validate()) {
                          return;
                        }
                      }

                      _updatePrice();

                      final updatePetDaycareReq = UpdatePetDaycareRequest(
                        petDaycareName: _nameController.text,
                        address: _address,
                        location: _searchController.text,
                        description: _descriptionController.text,
                        locality: _locality,
                        latitude: _latitude!,
                        longitude: _longitude!,
                        openingHour: _openingHoursController.text,
                        closingHour: _closingHoursController.text,
                        price: _prices,
                        pricingType: _pricingTypes,
                        hasPickupService: _pickupServiceProvided,
                        mustBeVaccinated: _petVaccinationRequired,
                        groomingAvailable: _groomingServiceProvided,
                        foodProvided: _foodProvided,
                        dailyWalksId: _dailyWalksId,
                        dailyPlaytimeId: _dailyPlaytimeId,
                        thumbnails: _images.whereType<File>().toList(),
                        petCategoryId: _petCategoryIds,
                        maxNumber: _maxNumbers,
                        thumbnailIndex: _thumbnailIndex,
                      );

                      // updatePetDaycareReq.thumbnails =
                      //     _images.whereType<File>().toList();
                      // if (updatePetDaycareReq.thumbnails.isEmpty) {
                      //   setState(() {
                      //     _errorText = "Must contains at least one image";
                      //   });
                      //   return;
                      // }

                      log(updatePetDaycareReq.toString());

                      ref
                          .read(petDaycareStateProvider.notifier)
                          .updatePetDaycare(value.id, updatePetDaycareReq);
                    },
                    child: Text("SAVE", style: defaultTextStyle),
                  )
                ],
                bottom: TabBar(tabs: [
                  Tab(
                    child: Text("Details", style: defaultTextStyle),
                  ),
                  Tab(
                    child: Text("Images", style: defaultTextStyle),
                  ),
                  Tab(
                    child: Text("Slots", style: defaultTextStyle),
                  ),
                  Tab(
                    child: Text("Services", style: defaultTextStyle),
                  ),
                ]),
              ),
              body: TabBarView(children: [
                _buildPetDaycareDetailsForm(context, value),
                _buildPetDaycareImagesForm(),
                _buildPetDaycareSlotsForm(context),
                _buildPetDaycareServiceForm(context),
              ]),
            ),
          );
        }),
      _ => Scaffold(
          appBar: AppBar(
            leading: appBarBackButton(context),
            title: Text(
              "Edit Pet Daycare",
              style: TextStyle(color: Colors.orange),
            ),
            centerTitle: false,
          ),
          body: Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          ),
        ),
    };
  }

  void _loadInitialValue(PetDaycareDetails value) {
    _nameController.text = value.name;
    _openingHoursController.text = value.openingHour;
    _closingHoursController.text = value.closingHour;
    _imageUrls = value.thumbnailUrls;
    _address = value.address;
    _locality = value.locality;
    _longitude = value.longitude;
    _latitude = value.latitude;
    _searchController.text = value.location;

    for (var pricing in value.pricings) {
      _existingPetCategoryId.add(pricing.petCategory.id);
    }

    for (var pricing in value.pricings) {
      // _petCategoryIds.add(pricing.petCategory.id);
      // _prices.add(pricing.price);
      // _pricingTypes.add(pricing.pricingType);
      // _maxNumbers.add(pricing.petCategory.slotAmount);

      if (pricing.petCategory.id == _miniatureDogID) {
        _acceptMiniatureDog = true;
        _miniatureDogPriceController.text = pricing.price.toInt().toString();
        _miniatureDogPricingTypeController.text = pricing.pricingType;
        _miniatureDogSlotController.text =
            pricing.petCategory.slotAmount.toString();
      }

      if (pricing.petCategory.id == _smallDogID) {
        _acceptSmallDog = true;
        _smallDogPriceController.text = pricing.price.toInt().toString();
        _smallDogPricingTypeController.text = pricing.pricingType;
        _smallDogSlotController.text =
            pricing.petCategory.slotAmount.toString();
      }
      if (pricing.petCategory.id == _mediumDogID) {
        _acceptMediumDog = true;
        _mediumDogPriceController.text = pricing.price.toInt().toString();
        _mediumDogPricingTypeController.text = pricing.pricingType;
        _mediumDogSlotController.text =
            pricing.petCategory.slotAmount.toString();
      }
      if (pricing.petCategory.id == _largeDogID) {
        _acceptLargeDog = true;
        _largeDogPriceController.text = pricing.price.toInt().toString();
        _largeDogPricingTypeController.text = pricing.pricingType;
        _largeDogSlotController.text =
            pricing.petCategory.slotAmount.toString();
      }
      if (pricing.petCategory.id == _giantDogID) {
        _acceptGiantDog = true;
        _giantDogPriceController.text = pricing.price.toInt().toString();
        _giantDogPricingTypeController.text = pricing.pricingType;
        _giantDogSlotController.text =
            pricing.petCategory.slotAmount.toString();
      }

      if (pricing.petCategory.id == 6) {
        _acceptCats = true;
        _catsPriceController.text = pricing.price.toInt().toString();
        _catsPricingTypeController.text = pricing.pricingType;
        _catsSlotController.text = pricing.petCategory.slotAmount.toString();
      }

      if (pricing.petCategory.id == 7) {
        _acceptBunnies = true;
        _bunniesPriceController.text = pricing.price.toInt().toString();
        _bunniesPricingTypeController.text = pricing.pricingType;
        _bunniesSlotController.text = pricing.petCategory.slotAmount.toString();
      }
    }

    if (value.description != "") {
      _descriptionController.text = value.description;
    }

    _foodProvided = value.foodProvided;
    _pickupServiceProvided = value.hasPickupService;
    _petVaccinationRequired = value.mustBeVaccinated;
    _groomingServiceProvided = value.groomingAvailable;

    _dailyWalkController.text = value.dailyWalks.name;
    _dailyPlaytimeController.text = value.dailyPlaytime.name;

    _dailyWalksId = value.dailyWalks.id;
    _dailyPlaytimeId = value.dailyPlaytime.id;
  }

  void _updatePrice() {
    if (_acceptMiniatureDog) {
      _petCategoryIds.add(_miniatureDogID);
      _prices.add(double.tryParse(_miniatureDogPriceController.text) ?? 0.0);
      _pricingTypes
          .add(_miniatureDogPricingTypeController.text == "day" ? 1 : 2);
      _maxNumbers.add(int.tryParse(_miniatureDogSlotController.text) ?? 0);
    } else {
      int index = _petCategoryIds.indexOf(_miniatureDogID);
      if (index != -1) {
        _petCategoryIds.removeAt(index);
        _prices.removeAt(index);
        _pricingTypes.removeAt(index);
        _maxNumbers.removeAt(index);
      }
    }

    if (_acceptSmallDog) {
      _petCategoryIds.add(_smallDogID);
      _prices.add(double.tryParse(_smallDogPriceController.text) ?? 0.0);
      _pricingTypes.add(_smallDogPricingTypeController.text == "day" ? 1 : 2);
      _maxNumbers.add(int.tryParse(_smallDogSlotController.text) ?? 0);
    } else {
      int index = _petCategoryIds.indexOf(_smallDogID);
      if (index != -1) {
        _petCategoryIds.removeAt(index);
        _prices.removeAt(index);
        _pricingTypes.removeAt(index);
        _maxNumbers.removeAt(index);
      }
    }

    if (_acceptMediumDog) {
      _petCategoryIds.add(_mediumDogID);
      _prices.add(double.tryParse(_mediumDogPriceController.text) ?? 0.0);
      _pricingTypes.add(_mediumDogPricingTypeController.text == "day" ? 1 : 2);
      _maxNumbers.add(int.tryParse(_mediumDogSlotController.text) ?? 0);
    } else {
      int index = _petCategoryIds.indexOf(_mediumDogID);
      if (index != -1) {
        _petCategoryIds.removeAt(index);
        _prices.removeAt(index);
        _pricingTypes.removeAt(index);
        _maxNumbers.removeAt(index);
      }
    }

    if (_acceptLargeDog) {
      _petCategoryIds.add(_largeDogID);
      _prices.add(double.tryParse(_largeDogPriceController.text) ?? 0.0);
      _pricingTypes.add(_largeDogPricingTypeController.text == "day" ? 1 : 2);
      _maxNumbers.add(int.tryParse(_largeDogSlotController.text) ?? 0);
    } else {
      int index = _petCategoryIds.indexOf(_largeDogID);
      if (index != -1) {
        _petCategoryIds.removeAt(index);
        _prices.removeAt(index);
        _pricingTypes.removeAt(index);
        _maxNumbers.removeAt(index);
      }
    }

    if (_acceptGiantDog) {
      _petCategoryIds.add(_giantDogID);
      _prices.add(double.tryParse(_giantDogPriceController.text) ?? 0.0);
      _pricingTypes.add(_giantDogPricingTypeController.text == "day" ? 1 : 2);
      _maxNumbers.add(int.tryParse(_giantDogSlotController.text) ?? 0);
    } else {
      int index = _petCategoryIds.indexOf(_giantDogID);
      if (index != -1) {
        _petCategoryIds.removeAt(index);
        _prices.removeAt(index);
        _pricingTypes.removeAt(index);
        _maxNumbers.removeAt(index);
      }
    }
    if (_acceptCats) {
      _petCategoryIds.add(6);
      _prices.add(double.tryParse(_catsPriceController.text) ?? 0.0);
      _pricingTypes.add(_catsPricingTypeController.text == "day" ? 1 : 2);
      _maxNumbers.add(int.tryParse(_catsSlotController.text) ?? 0);
    } else {
      int index = _petCategoryIds.indexOf(6);
      if (index != -1) {
        _petCategoryIds.removeAt(index);
        _prices.removeAt(index);
        _pricingTypes.removeAt(index);
        _maxNumbers.removeAt(index);
      }
    }

    if (_acceptBunnies) {
      _petCategoryIds.add(7);
      _prices.add(double.tryParse(_bunniesPriceController.text) ?? 0.0);
      _pricingTypes.add(_bunniesPricingTypeController.text == "day" ? 1 : 2);
      _maxNumbers.add(int.tryParse(_bunniesSlotController.text) ?? 0);
    } else {
      int index = _petCategoryIds.indexOf(7);
      if (index != -1) {
        _petCategoryIds.removeAt(index);
        _prices.removeAt(index);
        _pricingTypes.removeAt(index);
        _maxNumbers.removeAt(index);
      }
    }
  }

  Widget _buildPetDaycareServiceForm(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Requirements",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          CheckboxListTile(
            title: Text("Pet Vaccination Required"),
            value: _petVaccinationRequired,
            onChanged: (value) {
              setState(() {
                _petVaccinationRequired = value ?? false;
              });
            },
          ),
          Text(
            "Core Services",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          CheckboxListTile(
            title: Text("Grooming Provided"),
            value: _groomingServiceProvided,
            onChanged: (value) {
              setState(() {
                _groomingServiceProvided = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: Text("Pickup Provided"),
            value: _pickupServiceProvided,
            onChanged: (value) {
              setState(() {
                _pickupServiceProvided = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: Text("Food Provided"),
            value: _foodProvided,
            onChanged: (value) {
              setState(() {
                _foodProvided = value ?? false;
              });
            },
          ),
          Text(
            "Additional Services",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          Form(
            key: _petDaycareServiceFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextFormField(
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white70,
                    ),
                    controller: _dailyWalkController,
                    focusNode: _categoryFocusNode,
                    readOnly: true,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.navigate_next),
                      labelText: "Daily Walks Provided",
                      border: InputBorder.none,
                    ),
                    onTap: () async {
                      _categoryFocusNode.unfocus();

                      final out = await showModalBottomSheet<Lookup>(
                          context: context,
                          builder: (context) =>
                              SelectLookupModal(LookupCategory.dailyWalk));

                      if (out == null) {
                        return;
                      }
                      _dailyWalkController.text = out.name;
                      _dailyWalksId = out.id;
                    },
                    validator: (value) => validateNotEmpty("Input", value),
                  ),
                  TextFormField(
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white70,
                    ),
                    controller: _dailyPlaytimeController,
                    focusNode: _categoryFocusNode,
                    readOnly: true,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.navigate_next),
                      labelText: "Daily Playtime Provided",
                      border: InputBorder.none,
                    ),
                    onTap: () async {
                      _categoryFocusNode.unfocus();

                      final out = await showModalBottomSheet<Lookup>(
                          context: context,
                          builder: (context) =>
                              SelectLookupModal(LookupCategory.dailyPlaytime));

                      if (out == null) {
                        return;
                      }
                      _dailyPlaytimeController.text = out.name;
                      _dailyPlaytimeId = out.id;
                    },
                    validator: (value) => validateNotEmpty("Input", value),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPetDaycareSlotsForm(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: _petDaycareSlotsFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Dogs",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              _buildSizedCheckbox(
                "Miniature-Sized Breeds",
                "1 - 5kg",
                _acceptMiniatureDog,
                (val) {
                  setState(() {
                    _acceptMiniatureDog = val ?? false;
                  });
                },
              ),
              _priceSlotInput(
                context,
                _acceptMiniatureDog,
                _miniatureDogPriceController,
                _miniatureDogPricingTypeController,
                _miniatureDogSlotController,
              ),
              _buildSizedCheckbox(
                "Small-Sized Breeds",
                "5 - 10kg",
                _acceptSmallDog,
                (val) {
                  setState(() {
                    _acceptSmallDog = val ?? false;
                  });
                },
              ),
              _priceSlotInput(
                context,
                _acceptSmallDog,
                _smallDogPriceController,
                _smallDogPricingTypeController,
                _smallDogSlotController,
              ),
              _buildSizedCheckbox(
                "Medium-Sized Breeds",
                "10 - 25kg",
                _acceptMediumDog,
                (val) {
                  setState(() {
                    _acceptMediumDog = val ?? false;
                  });
                },
              ),
              _priceSlotInput(
                context,
                _acceptMediumDog,
                _mediumDogPriceController,
                _mediumDogPricingTypeController,
                _mediumDogSlotController,
              ),
              _buildSizedCheckbox(
                "Large-Sized Breeds",
                "25 - 45kg",
                _acceptLargeDog,
                (val) {
                  setState(() {
                    _acceptLargeDog = val ?? false;
                  });
                },
              ),
              _priceSlotInput(
                context,
                _acceptLargeDog,
                _largeDogPriceController,
                _largeDogPricingTypeController,
                _largeDogSlotController,
              ),
              _buildSizedCheckbox(
                "Giant-Sized Breeds",
                "45kg+",
                _acceptGiantDog,
                (val) {
                  setState(() {
                    _acceptGiantDog = val ?? false;
                  });
                },
              ),
              _priceSlotInput(
                context,
                _acceptGiantDog,
                _giantDogPriceController,
                _giantDogPricingTypeController,
                _giantDogSlotController,
              ),
              SizedBox(height: 20),
              Text("Others",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange)),
              _buildCheckboxTile("Accept cats?", _acceptCats, (value) {
                setState(() {
                  _acceptCats = value!;
                });
              }),
              _priceSlotInput(
                context,
                _acceptCats,
                _catsPriceController,
                _catsPricingTypeController,
                _catsSlotController,
              ),
              _buildCheckboxTile("Accept bunnies?", _acceptBunnies, (value) {
                setState(() {
                  _acceptBunnies = value!;
                });
              }),
              _priceSlotInput(
                context,
                _acceptBunnies,
                _bunniesPriceController,
                _bunniesPricingTypeController,
                _bunniesSlotController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetDaycareImagesForm() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 9,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _pickImage(index),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[300],
                    image: (_images[index] != null)
                        ? DecorationImage(
                            image: FileImage(_images[index]!),
                            fit: BoxFit.cover,
                          )
                        : (index < _imageUrls.length)
                            ? DecorationImage(
                                image: NetworkImage(_imageUrls[index]),
                                fit: BoxFit.cover,
                              )
                            : null,
                  ),
                  child: (_images[index] == null && _imageUrls.isEmpty)
                      ? Icon(Icons.image, color: Colors.black54, size: 32)
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black45,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // if (index == 0) {
                                  //   _pickImage(index); // Edit first image
                                  // } else {
                                  //   _deleteImage(index); // Delete other images
                                  // }
                                  _pickImage(index);
                                },
                              ),
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPetDaycareDetailsForm(
      BuildContext context, PetDaycareDetails value) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Form(
        key: _petDaycareDetailsFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            TextFormField(
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white70,
              ),
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
            _locationInput(value),
            _operationHoursInput(context),
            TextFormField(
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white70,
              ),
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
          ],
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
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white70,
                ),
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
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white70,
                ),
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

  Widget _locationInput(PetDaycareDetails value) {
    return SearchAnchor(
      searchController: _searchController,
      builder: (context, controller) {
        return TextFormField(
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white70,
          ),
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
            if (!controller.isOpen) controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          onTapOutside: (_) {
            if (controller.isOpen && controller.text.isNotEmpty) {
              controller.closeView(controller.text);
            }
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

  Widget _priceSlotInput(
      BuildContext context,
      bool enabled,
      TextEditingController priceController,
      TextEditingController pricingTypeController,
      TextEditingController slotController) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Text("Rp."),
        Expanded(
          child: TextFormField(
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white70,
            ),
            controller: priceController,
            enabled: enabled,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: "Price",
            ),
            keyboardType: TextInputType.number,
            validator: (value) => validatePriceInput(enabled, value),
          ),
        ),
        Text("/"),
        Expanded(
            child: TextFormField(
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white70,
          ),
          controller: pricingTypeController,
          enabled: enabled,
          readOnly: true,
          decoration: InputDecoration(
            labelText: "",
            suffixIcon: Icon(Icons.navigate_next),
          ),
          onTap: () async {
            pricingTypeController.text = await showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  margin: EdgeInsets.fromLTRB(12, 12, 12, 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Choose Pricing Type",
                        style: TextStyle(color: Colors.orange[600]),
                      ),
                      ListTile(
                        title: const Text("Day"),
                        onTap: () {
                          setState(() {
                            pricingTypeController.text = "day";
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text("Night"),
                        onTap: () {
                          setState(() {
                            pricingTypeController.text = "night";
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        )),
        Expanded(
          child: TextFormField(
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white70,
            ),
            controller: slotController,
            enabled: enabled,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: "# of Slot",
            ),
            keyboardType: TextInputType.number,
            validator: (value) => validateSlotInput(enabled, value),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxTile(
      String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSizedCheckbox(String title, String subtitle, bool val,
      void Function(bool?)? onChanged) {
    return CheckboxListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: val,
      onChanged: onChanged,
    );
  }
}
