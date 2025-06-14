import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/components/modals/select_pricing_type_modal.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/model/request/create_pet_daycare_request.dart';
import 'package:frontend/model/request/create_user_request.dart';
import 'package:frontend/pages/signup/create_pet_daycare_services.dart';
import 'package:frontend/provider/category_provider.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/validator.dart';
import 'package:intl/intl.dart';

class CreatePetDaycareSlots extends ConsumerStatefulWidget {
  final CreateUserRequest createUserReq;
  final CreatePetDaycareRequest createPetDaycareReq;

  const CreatePetDaycareSlots(
      {super.key,
      required this.createUserReq,
      required this.createPetDaycareReq});

  @override
  ConsumerState<CreatePetDaycareSlots> createState() =>
      _CreatePetDaycareSlotsState();
}

class _CreatePetDaycareSlotsState extends ConsumerState<CreatePetDaycareSlots> {
  final rupiahFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  static const _miniatureDogID = 1;
  static const _smallDogID = 2;
  static const _mediumDogID = 3;
  static const _largeDogID = 4;
  static const _giantDogID = 5;

  final _formKey = GlobalKey<FormState>();

  final _pricingTypeController = TextEditingController(text: "day");

  final _miniatureDogPriceController = TextEditingController();
  // final _miniatureDogPricingTypeController = TextEditingController(text: "day");
  final _miniatureDogSlotController = TextEditingController();

  final _smallDogPriceController = TextEditingController();
  // final _smallDogPricingTypeController = TextEditingController(text: "day");
  final _smallDogSlotController = TextEditingController();

  final _mediumDogPriceController = TextEditingController();
  // final _mediumDogPricingTypeController = TextEditingController(text: "day");
  final _mediumDogSlotController = TextEditingController();

  final _largeDogPriceController = TextEditingController();
  // final _largeDogPricingTypeController = TextEditingController(text: "day");
  final _largeDogSlotController = TextEditingController();

  final _giantDogPriceController = TextEditingController();
  // final _giantDogPricingTypeController = TextEditingController(text: "day");
  final _giantDogSlotController = TextEditingController();

  final _catsPriceController = TextEditingController();
  // final _catsPricingTypeController = TextEditingController(text: "day");
  final _catsSlotController = TextEditingController();

  final _bunniesPriceController = TextEditingController();
  // final _bunniesPricingTypeController = TextEditingController(text: "day");
  final _bunniesSlotController = TextEditingController();

  bool _acceptMiniatureDog = false;
  bool _acceptSmallDog = false;
  bool _acceptMediumDog = false;
  bool _acceptLargeDog = false;
  bool _acceptGiantDog = false;

  List<int> _petCategoryIds = [];
  List<double> _prices = [];
  int _pricingType = 1;
  String _pricingTypeName = "day";
  List<int> _maxNumbers = [];

  bool _acceptCats = false;
  bool _acceptBunnies = false;

  String? _error;

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _petCategoryIds = [];
    _prices = [];
    // _pricingTypes = [];
    _maxNumbers = [];

    if (!_acceptMiniatureDog &&
        !_acceptSmallDog &&
        !_acceptMediumDog &&
        !_acceptLargeDog &&
        !_acceptCats &&
        !_acceptBunnies) {
      setState(() {
        _error = AppLocalizations.of(context)!.mustAcceptAtLeastOnePet;
      });
      return;
    }

    if (_acceptMiniatureDog) {
      _petCategoryIds.add(_miniatureDogID);
      _prices.add(double.tryParse(_miniatureDogPriceController.text
              .replaceAll(RegExp(r'[^0-9]'), '')) ??
          0.0);
      // _pricingTypes
      //     .add(_miniatureDogPricingTypeController.text == "day" ? 1 : 2);
      _maxNumbers.add(int.tryParse(_miniatureDogSlotController.text) ?? 0);
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
      _petCategoryIds.add(_smallDogID);
      _prices.add(double.tryParse(_smallDogPriceController.text
              .replaceAll(RegExp(r'[^0-9]'), '')) ??
          0.0);
      // _pricingTypes.add(_smallDogPricingTypeController.text == "day" ? 1 : 2);
      _maxNumbers.add(int.tryParse(_smallDogSlotController.text) ?? 0);
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
      _petCategoryIds.add(_mediumDogID);
      _prices.add(double.tryParse(_mediumDogPriceController.text
              .replaceAll(RegExp(r'[^0-9]'), '')) ??
          0.0);
      // _pricingTypes.add(_mediumDogPricingTypeController.text == "day" ? 1 : 2);
      _maxNumbers.add(int.tryParse(_mediumDogSlotController.text) ?? 0);
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
      _petCategoryIds.add(_largeDogID);
      _prices.add(double.tryParse(_largeDogPriceController.text
              .replaceAll(RegExp(r'[^0-9]'), '')) ??
          0.0);
      // _pricingTypes.add(_largeDogPricingTypeController.text == "day" ? 1 : 2);
      _maxNumbers.add(int.tryParse(_largeDogSlotController.text) ?? 0);
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
      _petCategoryIds.add(_giantDogID);
      _prices.add(double.tryParse(_giantDogPriceController.text
              .replaceAll(RegExp(r'[^0-9]'), '')) ??
          0.0);
      // _pricingTypes.add(_giantDogPricingTypeController.text == "day" ? 1 : 2);
      _maxNumbers.add(int.tryParse(_giantDogSlotController.text) ?? 0);
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
      _petCategoryIds.add(6);
      _prices.add(double.tryParse(
              _catsPriceController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
          0.0);
      // _pricingTypes.add(_catsPricingTypeController.text == "day" ? 1 : 2);
      _maxNumbers.add(int.tryParse(_catsSlotController.text) ?? 0);
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
      _petCategoryIds.add(7);
      _prices.add(double.tryParse(
              _bunniesPriceController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
          0.0);
      // _pricingTypes.add(_bunniesPricingTypeController.text == "day" ? 1 : 2);
      _maxNumbers.add(int.tryParse(_bunniesSlotController.text) ?? 0);
    } else {
      int index = _petCategoryIds.indexOf(7);
      if (index != -1) {
        _petCategoryIds.removeAt(index);
        _prices.removeAt(index);
        // _pricingTypes.removeAt(index);
        _maxNumbers.removeAt(index);
      }
    }

    widget.createPetDaycareReq.price = _prices;
    widget.createPetDaycareReq.pricingType = _pricingType;
    widget.createPetDaycareReq.petCategoryId = _petCategoryIds;
    widget.createPetDaycareReq.maxNumber = _maxNumbers;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CreatePetDaycareServices(
        createPetDaycareReq: widget.createPetDaycareReq,
        createUserReq: widget.createUserReq,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final petCategory = ref.watch(petCategoryProvider);

    if (_error != null) {
      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //   var snackbar = SnackBar(
      //     key: Key("error-message"),
      //     content: Text(_error!),
      //     backgroundColor: Colors.red,
      //   );

      //   ScaffoldMessenger.of(context).showSnackBar(snackbar);
      //   _error = null;
      // });
      handleError(AsyncError(_error.toString(), StackTrace.current), context);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.manageYourPetSlots,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.primaryTextColor
                  : Colors.orange,
            ),
          ),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.primaryTextColor
                  : Colors.orange,
            ),
          ),
        ),
        body: switch (petCategory) {
          AsyncError() => ErrorText(
              errorText: AppLocalizations.of(context)!.somethingIsWrongTryAgain,
              onRefresh: () => ref.refresh(petCategoryProvider.future),
            ),
          AsyncData() => SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.pricingModel,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.light
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
                            color:
                                Theme.of(context).brightness == Brightness.light
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
                          // _miniatureDogPricingTypeController,
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
                          // _smallDogPricingTypeController,
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
                          // _mediumDogPricingTypeController,
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
                          // _largeDogPricingTypeController,
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
                          // _giantDogPricingTypeController,
                          _giantDogSlotController,
                        ),
                        SizedBox(height: 20),
                        Text(
                          AppLocalizations.of(context)!.others,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Constants.primaryTextColor
                                    : Colors.orange,
                          ),
                        ),
                        _buildCheckboxTile(
                            AppLocalizations.of(context)!.acceptCats,
                            _acceptCats, (value) {
                          setState(() {
                            _acceptCats = value!;
                          });
                        }),
                        _priceSlotInput(
                          context,
                          _acceptCats,
                          _catsPriceController,
                          // _catsPricingTypeController,
                          _catsSlotController,
                        ),
                        _buildCheckboxTile(
                            AppLocalizations.of(context)!.acceptBunnies,
                            _acceptBunnies, (value) {
                          setState(() {
                            _acceptBunnies = value!;
                          });
                        }),
                        _priceSlotInput(
                          context,
                          _acceptBunnies,
                          _bunniesPriceController,
                          // _bunniesPricingTypeController,
                          _bunniesSlotController,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text(
                            AppLocalizations.of(context)!.next,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 24)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          _ => Center(
                child: CircularProgressIndicator(
              color: Colors.orange,
            )),
        });
  }

  Widget _priceSlotInput(
      BuildContext context,
      bool enabled,
      TextEditingController priceController,
      // TextEditingController pricingTypeController,
      TextEditingController slotController) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Expanded(
          child: TextFormField(
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
              validateSlotInput(context, enabled, value);
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
