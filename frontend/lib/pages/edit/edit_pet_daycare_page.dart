import 'dart:developer';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_back_button.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/components/modals/select_lookup_modal.dart';
import 'package:frontend/components/modals/select_pricing_type_modal.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/model/pet_daycare.dart';
import 'package:frontend/model/request/update_pet_daycare_request.dart';
import 'package:frontend/model/response/mapbox/retrieve_response.dart';
import 'package:frontend/model/response/mapbox/suggest_response.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/provider/image_provider.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/pet_daycare_provider.dart';
import 'package:frontend/services/localization_service.dart';
import 'package:frontend/services/location_service.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class EditPetDaycarePage extends ConsumerStatefulWidget {
  final int petDaycareId;
  const EditPetDaycarePage(this.petDaycareId, {super.key});

  @override
  ConsumerState<EditPetDaycarePage> createState() => _EditPetDaycarePageState();
}

class _EditPetDaycarePageState extends ConsumerState<EditPetDaycarePage> {
  final rupiahFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  int _imageIndex = -1;

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

  Set<int> _uploadingIndices = {};

  String? _locationErrorText;

  // final List<File?> _images = List.filled(9, null);
  List<String?> _imageUrls = [];
  String? _errorText;

  final _sessionId = Uuid().v4();
  final ILocationService _locationService =
      FirebaseRemoteConfig.instance.getBool("mock_location_service")
          ? MockLocationService()
          : LocationService();

  final _pricingTypeController = TextEditingController(text: "day");

  final _miniatureDogPriceController = TextEditingController();
  final _miniatureDogSlotController = TextEditingController();

  final _smallDogPriceController = TextEditingController();
  final _smallDogSlotController = TextEditingController();

  final _mediumDogPriceController = TextEditingController();
  final _mediumDogSlotController = TextEditingController();

  final _largeDogPriceController = TextEditingController();
  final _largeDogSlotController = TextEditingController();

  final _giantDogPriceController = TextEditingController();
  final _giantDogSlotController = TextEditingController();

  final _catsPriceController = TextEditingController();
  final _catsSlotController = TextEditingController();

  final _bunniesPriceController = TextEditingController();
  final _bunniesSlotController = TextEditingController();

  bool _acceptMiniatureDog = false;
  bool _acceptSmallDog = false;
  bool _acceptMediumDog = false;
  bool _acceptLargeDog = false;
  bool _acceptGiantDog = false;

  final List<int> _petCategoryIds = [];
  final List<double> _prices = [];
  final List<int> _maxNumbers = [];

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
  int _pricingType = 1;
  String _pricingTypeName = "day";

  bool _isLoaded = false;

  TextStyle _defaultTextStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).brightness == Brightness.light
          ? Constants.primaryTextColor
          : Colors.orange,
      fontWeight: FontWeight.bold,
    );
  }

  String _addLeadingZeroIfNeeded(int value) {
    if (value < 10) {
      return '0$value';
    }
    return value.toString();
  }

  Future<void> _pickImage(int index) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageIndex = index;
          _uploadingIndices.add(_imageIndex);
        });
        log("pick image");
        // if (!_thumbnailIndex.contains(index + 1)) {
        //   _thumbnailIndex.add(index + 1);
        // }

        ref.read(imageStateProvider.notifier).upload(File(pickedFile.path));
        log("finish uploading");
        // setState(() {
        //   // _images[index] = File(pickedFile.path);
        //   _imageUrls[index] = ref.read(imageStateProvider).value?.imageUrl;
        // });
      }
    } catch (e) {
      log("_pickImage error: $e");
    }
  }

  void _deleteImage(int index) {
    setState(() {
      // _images[index] = null;
      _imageUrls[index] = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    log("[EDIT PET DAYCARE PAGE] build");
    log("image: ${_imageUrls}, _imageIndex: $_imageIndex");

    final petDaycare = ref.watch(getMyPetDaycareProvider);
    final petDaycareState = ref.watch(petDaycareStateProvider);
    final imageState = ref.watch(imageStateProvider);

    if (imageState.hasError && _imageIndex > -1) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        var snackbar = SnackBar(
          key: Key("error-message"),
          content: Text(
            imageState.error.toString(),
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red[800],
        );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);

        if (imageState.error.toString() == LocalizationService().jwtExpired ||
            imageState.error.toString() == LocalizationService().userDeleted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => WelcomeWidget(),
            ),
            (route) => false,
          );
        }

        setState(() {
          _uploadingIndices.remove(_imageIndex);
          _imageIndex = -1;
          ref.invalidate(imageStateProvider);
        });
      });
    }

    if (imageState.value != null && _imageIndex > -1) {
      log("image value ${imageState.value?.imageUrl}");
      _imageUrls[_imageIndex] = imageState.value?.imageUrl;
      setState(() {
        _uploadingIndices.remove(_imageIndex);
        _imageIndex = -1;
        log("updated image: ${_imageUrls}");
        ref.invalidate(imageStateProvider);
      });
      // ref.invalidate(imageStateProvider);
    }

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

    handleError(petDaycareState, context,
        ref.read(petDaycareStateProvider.notifier).reset);
    if (imageState.hasError &&
        (imageState.valueOrNull == null || imageState.valueOrNull == 0) &&
        !imageState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        var snackbar = SnackBar(
          key: Key("error-message"),
          content: Text(
            imageState.error.toString(),
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red[800],
        );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);

        if (imageState.error.toString() == LocalizationService().jwtExpired ||
            imageState.error.toString() == LocalizationService().userDeleted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => WelcomeWidget(),
            ),
            (route) => false,
          );
        }

        Navigator.of(context).pop();

        ref.read(imageStateProvider.notifier).reset();
      });
    }

    if (petDaycareState.hasValue &&
        !petDaycareState.hasError &&
        !petDaycareState.isLoading) {
      if (petDaycareState.value == 204) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          ref.invalidate(getMyPetDaycareProvider);
          ref.read(petDaycareStateProvider.notifier).reset();

          Navigator.of(context).pop(true);
        });
      }
    }
    // handleValue(petDaycareState, this,
    //     ref.read(petDaycareStateProvider.notifier).reset);

    return switch (petDaycare) {
      AsyncError(:final error) => Scaffold(
          appBar: AppBar(
            leading: appBarBackButton(context),
            title: Text(
              AppLocalizations.of(context)!.editPetDaycare,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Constants.primaryTextColor
                    : Colors.orange,
              ),
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
                  AppLocalizations.of(context)!.editDaycare,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Constants.primaryTextColor
                        : Colors.orange,
                  ),
                ),
                centerTitle: false,
                actions: [
                  IconButton(
                    onPressed: () {
                      if (imageState.isLoading) return;
                      if (_latitude == null && _longitude == null) {
                        setState(() {
                          _errorText =
                              AppLocalizations.of(context)!.invalidLocation;
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
                        pricingType: _pricingType,
                        hasPickupService: _pickupServiceProvided,
                        mustBeVaccinated: _petVaccinationRequired,
                        groomingAvailable: _groomingServiceProvided,
                        foodProvided: _foodProvided,
                        dailyWalksId: _dailyWalksId,
                        dailyPlaytimeId: _dailyPlaytimeId,
                        thumbnails: _imageUrls.whereType<String>().toList(),
                        petCategoryId: _petCategoryIds,
                        maxNumber: _maxNumbers,
                      );

                      log(updatePetDaycareReq.toString());

                      ref
                          .read(petDaycareStateProvider.notifier)
                          .updatePetDaycare(value.id, updatePetDaycareReq);
                    },
                    icon: !petDaycareState.isLoading && !imageState.isLoading
                        ? Icon(
                            Icons.save,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Constants.primaryTextColor
                                    : Colors.orange,
                          )
                        : CircularProgressIndicator(),
                  )
                ],
                bottom: TabBar(tabs: [
                  Tab(
                    child: Text(
                      AppLocalizations.of(context)!.detailsTab,
                      style: _defaultTextStyle(context),
                    ),
                  ),
                  Tab(
                    child: Text(
                      AppLocalizations.of(context)!.imagesTab,
                      style: _defaultTextStyle(context),
                    ),
                  ),
                  Tab(
                    child: Text(
                      AppLocalizations.of(context)!.slotsTab,
                      style: _defaultTextStyle(context),
                    ),
                  ),
                  Tab(
                    child: Text(
                      AppLocalizations.of(context)!.servicesTab,
                      style: _defaultTextStyle(context),
                    ),
                  ),
                ]),
              ),
              body: SafeArea(
                child: TabBarView(children: [
                  _buildPetDaycareDetailsForm(context, value),
                  _buildPetDaycareImagesForm(),
                  _buildPetDaycareSlotsForm(context),
                  _buildPetDaycareServiceForm(context),
                ]),
              ),
            ),
          );
        }),
      _ => Scaffold(
          appBar: AppBar(
            leading: appBarBackButton(context),
            title: Text(
              AppLocalizations.of(context)!.editPetDaycare,
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

    _imageUrls = List<String?>.from(_imageUrls)
      ..addAll(List<String?>.filled(9 - _imageUrls.length, null));

    for (var pricing in value.pricings) {
      _existingPetCategoryId.add(pricing.petCategory.id);
    }

    _pricingType = value.pricings[0].pricingType.id;
    _pricingTypeName = value.pricings[0].pricingType.name;
    _pricingTypeController.text = _pricingTypeName;

    for (var pricing in value.pricings) {
      // _petCategoryIds.add(pricing.petCategory.id);
      // _prices.add(pricing.price);
      // _pricingTypes.add(pricing.pricingType);
      // _maxNumbers.add(pricing.petCategory.slotAmount);

      if (pricing.petCategory.id == _miniatureDogID) {
        _acceptMiniatureDog = true;
        _miniatureDogPriceController.text = rupiahFormat.format(pricing.price);
        // _miniatureDogPricingTypeController.text = pricing.pricingType.name;
        _miniatureDogSlotController.text =
            pricing.petCategory.slotAmount.toString();
      }

      if (pricing.petCategory.id == _smallDogID) {
        _acceptSmallDog = true;
        _smallDogPriceController.text = rupiahFormat.format(pricing.price);
        // _smallDogPricingTypeController.text = pricing.pricingType.name;
        _smallDogSlotController.text =
            pricing.petCategory.slotAmount.toString();
      }
      if (pricing.petCategory.id == _mediumDogID) {
        _acceptMediumDog = true;
        _mediumDogPriceController.text = rupiahFormat.format(pricing.price);
        // _mediumDogPricingTypeController.text = pricing.pricingType.name;
        _mediumDogSlotController.text =
            pricing.petCategory.slotAmount.toString();
      }
      if (pricing.petCategory.id == _largeDogID) {
        _acceptLargeDog = true;
        _largeDogPriceController.text = rupiahFormat.format(pricing.price);
        // _largeDogPricingTypeController.text = pricing.pricingType.name;
        _largeDogSlotController.text =
            pricing.petCategory.slotAmount.toString();
      }
      if (pricing.petCategory.id == _giantDogID) {
        _acceptGiantDog = true;
        _giantDogPriceController.text = rupiahFormat.format(pricing.price);
        // _giantDogPricingTypeController.text = pricing.pricingType.name;
        _giantDogSlotController.text =
            pricing.petCategory.slotAmount.toString();
      }

      if (pricing.petCategory.id == 6) {
        _acceptCats = true;
        _catsPriceController.text = rupiahFormat.format(pricing.price);
        // _catsPricingTypeController.text = pricing.pricingType.name;
        _catsSlotController.text = pricing.petCategory.slotAmount.toString();
      }

      if (pricing.petCategory.id == 7) {
        _acceptBunnies = true;
        _bunniesPriceController.text = rupiahFormat.format(pricing.price);
        // _bunniesPricingTypeController.text = pricing.pricingType.name;
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
      if (!_petCategoryIds.contains(_miniatureDogID)) {
        _petCategoryIds.add(_miniatureDogID);
        _prices.add(double.tryParse(_miniatureDogPriceController.text
                .replaceAll(RegExp(r'[^0-9]'), '')) ??
            0.0);
        // _pricingTypes
        // .add(_miniatureDogPricingTypeController.text == "day" ? 1 : 2);
        _maxNumbers.add(int.tryParse(_miniatureDogSlotController.text) ?? 0);
      }
    } else {
      int index = _petCategoryIds.indexOf(_miniatureDogID);
      if (index != -1) {
        _petCategoryIds.removeAt(index);
        _prices.removeAt(index);
        // _pricingTypes.removeAt(index);
        _maxNumbers.removeAt(index);
      }
    }

    if (_acceptSmallDog) {
      if (!_petCategoryIds.contains(_smallDogID)) {
        _petCategoryIds.add(_smallDogID);
        _prices.add(double.tryParse(_smallDogPriceController.text
                .replaceAll(RegExp(r'[^0-9]'), '')) ??
            0.0);
        // _pricingTypes.add(_smallDogPricingTypeController.text == "day" ? 1 : 2);
        _maxNumbers.add(int.tryParse(_smallDogSlotController.text) ?? 0);
      }
    } else {
      int index = _petCategoryIds.indexOf(_smallDogID);
      if (index != -1) {
        _petCategoryIds.removeAt(index);
        _prices.removeAt(index);
        // _pricingTypes.removeAt(index);
        _maxNumbers.removeAt(index);
      }
    }

    if (_acceptMediumDog) {
      if (!_petCategoryIds.contains(_mediumDogID)) {
        _petCategoryIds.add(_mediumDogID);
        _prices.add(double.tryParse(_mediumDogPriceController.text
                .replaceAll(RegExp(r'[^0-9]'), '')) ??
            0.0);
        // _pricingTypes
        // .add(_mediumDogPricingTypeController.text == "day" ? 1 : 2);
        _maxNumbers.add(int.tryParse(_mediumDogSlotController.text) ?? 0);
      }
    } else {
      int index = _petCategoryIds.indexOf(_mediumDogID);
      if (index != -1) {
        _petCategoryIds.removeAt(index);
        _prices.removeAt(index);
        // _pricingTypes.removeAt(index);
        _maxNumbers.removeAt(index);
      }
    }

    if (_acceptLargeDog) {
      if (!_petCategoryIds.contains(_largeDogID)) {
        _petCategoryIds.add(_largeDogID);
        _prices.add(double.tryParse(_largeDogPriceController.text
                .replaceAll(RegExp(r'[^0-9]'), '')) ??
            0.0);
        // _pricingTypes.add(_largeDogPricingTypeController.text == "day" ? 1 : 2);
        _maxNumbers.add(int.tryParse(_largeDogSlotController.text) ?? 0);
      }
    } else {
      int index = _petCategoryIds.indexOf(_largeDogID);
      if (index != -1) {
        _petCategoryIds.removeAt(index);
        _prices.removeAt(index);
        // _pricingTypes.removeAt(index);
        _maxNumbers.removeAt(index);
      }
    }

    if (_acceptGiantDog) {
      if (!_petCategoryIds.contains(_giantDogID)) {
        _petCategoryIds.add(_giantDogID);
        _prices.add(double.tryParse(_giantDogPriceController.text
                .replaceAll(RegExp(r'[^0-9]'), '')) ??
            0.0);
        // _pricingTypes.add(_giantDogPricingTypeController.text == "day" ? 1 : 2);
        _maxNumbers.add(int.tryParse(_giantDogSlotController.text) ?? 0);
      }
    } else {
      int index = _petCategoryIds.indexOf(_giantDogID);
      if (index != -1) {
        _petCategoryIds.removeAt(index);
        _prices.removeAt(index);
        // _pricingTypes.removeAt(index);
        _maxNumbers.removeAt(index);
      }
    }
    if (_acceptCats) {
      if (!_petCategoryIds.contains(6)) {
        _petCategoryIds.add(6);
        _prices.add(double.tryParse(
                _catsPriceController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
            0.0);
        // _pricingTypes.add(_catsPricingTypeController.text == "day" ? 1 : 2);
        _maxNumbers.add(int.tryParse(_catsSlotController.text) ?? 0);
      }
    } else {
      int index = _petCategoryIds.indexOf(6);
      if (index != -1) {
        _petCategoryIds.removeAt(index);
        _prices.removeAt(index);
        // _pricingTypes.removeAt(index);
        _maxNumbers.removeAt(index);
      }
    }

    if (_acceptBunnies) {
      if (!_petCategoryIds.contains(7)) {
        _petCategoryIds.add(7);
        _prices.add(double.tryParse(_bunniesPriceController.text
                .replaceAll(RegExp(r'[^0-9]'), '')) ??
            0.0);
        // _pricingTypes.add(_bunniesPricingTypeController.text == "day" ? 1 : 2);
        _maxNumbers.add(int.tryParse(_bunniesSlotController.text) ?? 0);
      }
    } else {
      int index = _petCategoryIds.indexOf(7);
      if (index != -1) {
        _petCategoryIds.removeAt(index);
        _prices.removeAt(index);
        // _pricingTypes.removeAt(index);
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
            AppLocalizations.of(context)!.requirements,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.primaryTextColor
                  : Colors.orange,
            ),
          ),
          CheckboxListTile(
            title: Text(AppLocalizations.of(context)!.petVaccinationRequired),
            value: _petVaccinationRequired,
            onChanged: (value) {
              setState(() {
                _petVaccinationRequired = value ?? false;
              });
            },
          ),
          Text(
            AppLocalizations.of(context)!.additionalServices,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.primaryTextColor
                  : Colors.orange,
            ),
          ),
          CheckboxListTile(
            title: Text(AppLocalizations.of(context)!.groomingProvided),
            value: _groomingServiceProvided,
            onChanged: (value) {
              setState(() {
                _groomingServiceProvided = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: Text(AppLocalizations.of(context)!.pickupProvided),
            value: _pickupServiceProvided,
            onChanged: (value) {
              setState(() {
                _pickupServiceProvided = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: Text(AppLocalizations.of(context)!.inHouseFoodProvided),
            value: _foodProvided,
            onChanged: (value) {
              setState(() {
                _foodProvided = value ?? false;
              });
            },
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
                      labelText:
                          AppLocalizations.of(context)!.dailyWalksProvided,
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
                    validator: (value) => validateNotEmpty(context, value),
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
                      labelText:
                          AppLocalizations.of(context)!.dailyPlaytimeProvided,
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
                    validator: (value) => validateNotEmpty(context, value),
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
                AppLocalizations.of(context)!.pricingModel,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Constants.primaryTextColor
                      : Colors.orange,
                ),
              ),
              TextField(
                controller: _pricingTypeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "",
                  suffixIcon: Icon(Icons.navigate_next),
                ),
                onTap: () async {
                  var out = await showModalBottomSheet<Lookup>(
                    context: context,
                    builder: (context) => SelectPricingTypeModal(),
                  );

                  if (out == null) {
                    return;
                  }

                  setState(() {
                    _pricingTypeController.text = out.name;
                    _pricingTypeName = out.name;
                  });
                  _pricingType = out.id;
                },
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.dogs,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Constants.primaryTextColor
                      : Colors.orange,
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
                _giantDogSlotController,
              ),
              SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.others,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Constants.primaryTextColor
                      : Colors.orange,
                ),
              ),
              _buildCheckboxTile(
                  AppLocalizations.of(context)!.acceptCats, _acceptCats,
                  (value) {
                setState(() {
                  _acceptCats = value!;
                });
              }),
              _priceSlotInput(
                context,
                _acceptCats,
                _catsPriceController,
                _catsSlotController,
              ),
              _buildCheckboxTile(
                  AppLocalizations.of(context)!.acceptBunnies, _acceptBunnies,
                  (value) {
                setState(() {
                  _acceptBunnies = value!;
                });
              }),
              _priceSlotInput(
                context,
                _acceptBunnies,
                _bunniesPriceController,
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
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 9,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final isUploading = _uploadingIndices.contains(index);
              final imageUrl = _imageUrls[index];

              Widget child;
              if (isUploading) {
                child =
                    const Center(child: CircularProgressIndicator.adaptive());
              } else if (imageUrl != null) {
                child = Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      },
                      errorBuilder: (context, error, stack) {
                        return const Icon(Icons.broken_image,
                            color: Colors.black54);
                      },
                    ),
                    // Overlay for edit/delete
                    Container(
                      color: Colors.black.withValues(alpha: 0.4),
                      child: Center(
                        child: IconButton(
                          icon: Icon(
                            index == 0 ? Icons.edit : Icons.delete,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (index == 0) {
                              _pickImage(index);
                            } else {
                              _deleteImage(index);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                // Placeholder to add an image
                child = Center(
                  child: IconButton(
                    icon: const Icon(Icons.add_a_photo_outlined,
                        color: Colors.black54),
                    onPressed: () {
                      if (ref.read(imageStateProvider).isLoading) return;
                      _pickImage(index);
                    },
                  ),
                );
              }

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300],
                ),
                clipBehavior: Clip.antiAlias, // Ensures child respects radius
                child: child,
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
                labelText: AppLocalizations.of(context)!.petDaycareName,
                errorText: _locationErrorText,
              ),
              validator: (value) => validateNotEmpty(context, value),
            ),
            _locationInput(value),
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
                labelText: AppLocalizations.of(context)!.descriptionOptional,
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
          AppLocalizations.of(context)!.operatingHours,
          style: _defaultTextStyle(context),
        ),
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: TextFormField(
                readOnly: true,
                controller: _openingHoursController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.openingHour,
                  labelStyle: TextStyle(fontSize: 12),
                  suffixIcon: Icon(
                    Icons.navigate_next,
                    size: 20,
                  ),
                ),
                validator: (value) => validateNotEmpty(context, value),
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
            Text(AppLocalizations.of(context)!.to),
            Expanded(
              child: TextFormField(
                readOnly: true,
                controller: _closingHoursController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.closingHour,
                  labelStyle: TextStyle(fontSize: 12),
                  suffixIcon: Icon(
                    Icons.navigate_next,
                    size: 20,
                  ),
                ),
                validator: (value) => validateNotEmpty(context, value),
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
          validator: (value) => validateNotEmpty(context, value),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            labelText: AppLocalizations.of(context)!.location,
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
                        content: Text(
                            AppLocalizations.of(context)!.fetchAddressError),
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
      TextEditingController slotController) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
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
              labelText: AppLocalizations.of(context)!.price,
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              if (value.isNotEmpty) {
                priceController.text = rupiahFormat.format(int.parse(value));
              }
            },
            validator: (value) {
              if (!enabled) return null;
              return validatePriceInput(context, enabled, value);
            },
          ),
        ),
        Text(AppLocalizations.of(context)!.perPricingModel(_pricingTypeName)),
        // Expanded(
        //     child: TextFormField(
        //   style: TextStyle(
        //     color: Theme.of(context).brightness == Brightness.light
        //         ? Colors.black
        //         : Colors.white70,
        //   ),
        //   controller: pricingTypeController,
        //   enabled: enabled,
        //   readOnly: true,
        //   decoration: InputDecoration(
        //     labelText: "",
        //     suffixIcon: Icon(Icons.navigate_next),
        //   ),
        //   onTap: () async {
        //     pricingTypeController.text = await showModalBottomSheet(
        //       context: context,
        //       builder: (context) {
        //         return Container(
        //           margin: EdgeInsets.fromLTRB(12, 12, 12, 32),
        //           child: Column(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               Text(
        //                 "Choose Pricing Type",
        //                 style: TextStyle(color: Colors.orange[600]),
        //               ),
        //               ListTile(
        //                 title: const Text("Day"),
        //                 onTap: () {
        //                   setState(() {
        //                     pricingTypeController.text = "day";
        //                   });
        //                   Navigator.pop(context);
        //                 },
        //               ),
        //               ListTile(
        //                 title: const Text("Night"),
        //                 onTap: () {
        //                   setState(() {
        //                     pricingTypeController.text = "night";
        //                   });
        //                   Navigator.pop(context);
        //                 },
        //               ),
        //             ],
        //           ),
        //         );
        //       },
        //     );
        //   },
        // )),
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
              labelText: AppLocalizations.of(context)!.numberOfSlots,
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (!enabled) return null;
              return validateSlotInput(context, enabled, value);
            },
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
