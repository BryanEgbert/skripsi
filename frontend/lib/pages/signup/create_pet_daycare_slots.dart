import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/model/request/create_pet_daycare_request.dart';
import 'package:frontend/model/request/create_user_request.dart';
import 'package:frontend/pages/signup/create_pet_daycare_services.dart';
import 'package:frontend/provider/category_provider.dart';
import 'package:frontend/utils/validator.dart';

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
  static const _miniatureDogID = 1;
  static const _smallDogID = 2;
  static const _mediumDogID = 3;
  static const _largeDogID = 4;
  static const _giantDogID = 5;

  final _formKey = GlobalKey<FormState>();

  final _allDogSizePriceController = TextEditingController();
  final _allDogSizePricingTypeController = TextEditingController(text: "day");
  final _allDogSizeSlotController = TextEditingController();

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

  bool _acceptDogs = false;
  bool _acceptMiniatureDog = false;
  bool _acceptSmallDog = false;
  bool _acceptMediumDog = false;
  bool _acceptLargeDog = false;
  bool _acceptGiantDog = false;

  List<int> _petCategoryIds = [];
  List<double> _prices = [];
  List<String> _pricingTypes = [];
  List<int> _maxNumbers = [];

  bool _separateBySize = false;
  bool _acceptCats = false;
  bool _acceptBunnies = false;

  String? _error;

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _petCategoryIds = [];
    _prices = [];
    _pricingTypes = [];
    _maxNumbers = [];

    if (!_acceptDogs &&
        !_acceptSmallDog &&
        !_acceptMediumDog &&
        !_acceptLargeDog &&
        !_acceptCats &&
        !_acceptBunnies) {
      setState(() {
        _error = "Must accept at least one pet";
      });
      return;
    }

    if (_separateBySize == false) {
      var ids = [
        _miniatureDogID,
        _smallDogID,
        _mediumDogID,
        _largeDogID,
        _giantDogID
      ];
      _petCategoryIds.addAll(ids);

      for (var i = 0; i < ids.length; i++) {
        _prices.add(double.tryParse(_allDogSizePriceController.text) ?? 0.0);
        _pricingTypes.add(_allDogSizePricingTypeController.text);
        _maxNumbers.add(int.tryParse(_allDogSizeSlotController.text) ?? 0);
      }
    } else {
      if (_acceptMiniatureDog) {
        _petCategoryIds.add(_miniatureDogID);
        _prices.add(double.tryParse(_miniatureDogPriceController.text) ?? 0.0);
        _pricingTypes.add(_miniatureDogPricingTypeController.text);
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
        _pricingTypes.add(_smallDogPricingTypeController.text);
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
        _pricingTypes.add(_mediumDogPricingTypeController.text);
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
        _pricingTypes.add(_largeDogPricingTypeController.text);
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
        _pricingTypes.add(_giantDogPricingTypeController.text);
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
    }

    if (_acceptCats) {
      _petCategoryIds.add(6);
      _prices.add(double.tryParse(_catsPriceController.text) ?? 0.0);
      _pricingTypes.add(_catsPricingTypeController.text);
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
      _pricingTypes.add(_bunniesPricingTypeController.text);
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

    log("[INFO] prices: $_prices, pet category: $_petCategoryIds, pricingType: $_pricingTypes, maxNumbers: $_maxNumbers");

    widget.createPetDaycareReq.price = _prices;
    widget.createPetDaycareReq.pricingType = _pricingTypes;
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

    log("[INFO] prices: $_prices, pet category: $_petCategoryIds, pricingType: $_pricingTypes");
    log("[INFO] acceptSmallDog: $_acceptSmallDog, separateBySize: $_separateBySize");

    if (_error != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        var snackbar = SnackBar(
          key: Key("error-message"),
          content: Text(_error!),
          backgroundColor: Colors.red,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        _error = null;
      });
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Manage Your Pet Slots",
            style: TextStyle(color: Colors.orange),
          ),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios,
            ),
          ),
        ),
        body: switch (petCategory) {
          AsyncError(:final error) => ErrorText(
              errorText:
                  "Something is wrong, please try again later\nerror message: $error",
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
                          "Dogs",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        CheckboxListTile(
                          title: Text("Accept Dogs?"),
                          subtitle:
                              Text("Check if you allow dogs in your daycare"),
                          value: _acceptDogs,
                          onChanged: (value) {
                            setState(() {
                              _acceptDogs = value!;
                            });
                          },
                        ),
                        if (_acceptDogs) ...[
                          RadioListTile(
                            title: Text("All-Sized Dogs"),
                            subtitle:
                                Text("One capacity for dogs of any size."),
                            value: false,
                            groupValue: _separateBySize,
                            onChanged: (value) {
                              setState(() {
                                _separateBySize = value as bool;
                              });
                            },
                          ),
                          _priceSlotInput(
                            context,
                            !_separateBySize,
                            _allDogSizePriceController,
                            _allDogSizePricingTypeController,
                            _allDogSizeSlotController,
                          ),
                          RadioListTile(
                            title: Text("Separate by Size"),
                            subtitle:
                                Text("Different capacities for each size."),
                            value: true,
                            groupValue: _separateBySize,
                            onChanged: (value) {
                              setState(() {
                                _separateBySize = value as bool;
                              });
                            },
                          ),
                          if (_separateBySize) ...[
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
                          ],
                        ],
                        SizedBox(height: 20),
                        Text("Others",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange)),
                        _buildCheckboxTile("Accept cats?", _acceptCats,
                            (value) {
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
                        _buildCheckboxTile("Accept bunnies?", _acceptBunnies,
                            (value) {
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
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text(
                            "Next",
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
      TextEditingController pricingTypeController,
      TextEditingController slotController) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Text("Rp."),
        Expanded(
          child: TextFormField(
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
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: CheckboxListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: val,
        onChanged: onChanged,
      ),
    );
  }
}
