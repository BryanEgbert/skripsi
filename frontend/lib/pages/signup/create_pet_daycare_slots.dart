import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/model/request/create_pet_daycare_request.dart';
import 'package:frontend/model/request/create_user_request.dart';
import 'package:frontend/pages/signup/create_pet_daycare_services.dart';
import 'package:frontend/provider/category_provider.dart';

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
  final _allDogSizePriceController = TextEditingController();
  final _allDogSizePricingTypeController = TextEditingController();
  final _allDogSizeSlotController = TextEditingController();

  final _smallDogPriceController = TextEditingController();
  final _smallDogPricingTypeController = TextEditingController();
  final _smallDogSlotController = TextEditingController();

  final _mediumDogPriceController = TextEditingController();
  final _mediumDogPricingTypeController = TextEditingController();
  final _mediumDogSlotController = TextEditingController();

  final _largeDogPriceController = TextEditingController();
  final _largeDogPricingTypeController = TextEditingController();
  final _largeDogSlotController = TextEditingController();

  final _catsPriceController = TextEditingController();
  final _catsPricingTypeController = TextEditingController();
  final _catsSlotController = TextEditingController();

  final _bunniesPriceController = TextEditingController();
  final _bunniesPricingTypeController = TextEditingController();
  final _bunniesSlotController = TextEditingController();

  bool _acceptDogs = false;
  bool _acceptSmallDog = false;
  bool _acceptMediumDog = false;
  bool _acceptLargeDog = false;

  List<int> _petCategoryIds = [];
  List<double> _prices = [];
  List<String> _pricingTypes = [];
  List<int> _maxNumbers = [];

  bool _separateBySize = false;
  bool _acceptCats = false;
  bool _acceptBunnies = false;

  void _submitForm() {
    _petCategoryIds = [];
    _prices = [];
    _pricingTypes = [];
    _maxNumbers = [];

    if (_separateBySize == false) {
      _petCategoryIds.addAll([1, 2, 3]);

      _prices.add(double.tryParse(_allDogSizePriceController.text) ?? 0.0);
      _prices.add(double.tryParse(_allDogSizePriceController.text) ?? 0.0);
      _prices.add(double.tryParse(_allDogSizePriceController.text) ?? 0.0);

      _pricingTypes.add(_allDogSizePricingTypeController.text);
      _pricingTypes.add(_allDogSizePricingTypeController.text);
      _pricingTypes.add(_allDogSizePricingTypeController.text);

      _maxNumbers.add(int.tryParse(_allDogSizeSlotController.text) ?? 0);
      _maxNumbers.add(int.tryParse(_allDogSizeSlotController.text) ?? 0);
      _maxNumbers.add(int.tryParse(_allDogSizeSlotController.text) ?? 0);
    } else {
      if (_acceptSmallDog) {
        _petCategoryIds.add(1);
        _prices.add(double.tryParse(_smallDogPriceController.text) ?? 0.0);
        _pricingTypes.add(_smallDogPricingTypeController.text);
        _maxNumbers.add(int.tryParse(_smallDogSlotController.text) ?? 0);
      } else {
        int index = _petCategoryIds.indexOf(1);
        if (index != -1) {
          _petCategoryIds.removeAt(index);
          _prices.removeAt(index);
          _pricingTypes.removeAt(index);
          _maxNumbers.removeAt(index);
        }
      }

      if (_acceptMediumDog) {
        _petCategoryIds.add(2);
        _prices.add(double.tryParse(_mediumDogPriceController.text) ?? 0.0);
        _pricingTypes.add(_mediumDogPricingTypeController.text);
        _maxNumbers.add(int.tryParse(_mediumDogSlotController.text) ?? 0);
      } else {
        int index = _petCategoryIds.indexOf(2);
        if (index != -1) {
          _petCategoryIds.removeAt(index);
          _prices.removeAt(index);
          _pricingTypes.removeAt(index);
          _maxNumbers.removeAt(index);
        }
      }

      if (_acceptLargeDog) {
        _petCategoryIds.add(3);
        _prices.add(double.tryParse(_largeDogPriceController.text) ?? 0.0);
        _pricingTypes.add(_largeDogPricingTypeController.text);
        _maxNumbers.add(int.tryParse(_largeDogSlotController.text) ?? 0);
      } else {
        int index = _petCategoryIds.indexOf(3);
        if (index != -1) {
          _petCategoryIds.removeAt(index);
          _prices.removeAt(index);
          _pricingTypes.removeAt(index);
          _maxNumbers.removeAt(index);
        }
      }
    }
    // if (_separateBySize && _acceptSmallDog) {
    //   petCategoryIds.add(1);
    //   prices.add(double.tryParse(_smallDogPriceController.text) ?? 0.0);
    //   pricingTypes.add(_smallDogPricingTypeController.text);
    //   maxNumbers.add(int.tryParse(_smallDogSlotController.text) ?? 0);
    // } else {
    //   int index = petCategoryIds.indexOf(1);
    //   if (index != -1) {
    //     petCategoryIds.removeAt(index);
    //     prices.removeAt(index);
    //     pricingTypes.removeAt(index);
    //     maxNumbers.removeAt(index);
    //   }
    // }

    // if (_separateBySize && _acceptMediumDog) {
    //   petCategoryIds.add(2);
    //   prices.add(double.tryParse(_mediumDogPriceController.text) ?? 0.0);
    //   pricingTypes.add(_mediumDogPricingTypeController.text);
    //   maxNumbers.add(int.tryParse(_mediumDogSlotController.text) ?? 0);
    // } else {
    //   int index = petCategoryIds.indexOf(2);
    //   if (index != -1) {
    //     petCategoryIds.removeAt(index);
    //     prices.removeAt(index);
    //     pricingTypes.removeAt(index);
    //     maxNumbers.removeAt(index);
    //   }
    // }

    // if (_separateBySize && _acceptLargeDog) {
    //   petCategoryIds.add(3);
    //   prices.add(double.tryParse(_largeDogPriceController.text) ?? 0.0);
    //   pricingTypes.add(_largeDogPricingTypeController.text);
    //   maxNumbers.add(int.tryParse(_largeDogSlotController.text) ?? 0);
    // } else {
    //   int index = petCategoryIds.indexOf(3);
    //   if (index != -1) {
    //     petCategoryIds.removeAt(index);
    //     prices.removeAt(index);
    //     pricingTypes.removeAt(index);
    //     maxNumbers.removeAt(index);
    //   }
    // }

    if (_acceptCats) {
      _petCategoryIds.add(4);
      _prices.add(double.tryParse(_catsPriceController.text) ?? 0.0);
      _pricingTypes.add(_catsPricingTypeController.text);
      _maxNumbers.add(int.tryParse(_catsSlotController.text) ?? 0);
    } else {
      int index = _petCategoryIds.indexOf(4);
      if (index != -1) {
        _petCategoryIds.removeAt(index);
        _prices.removeAt(index);
        _pricingTypes.removeAt(index);
        _maxNumbers.removeAt(index);
      }
    }

    if (_acceptBunnies) {
      _petCategoryIds.add(5);
      _prices.add(double.tryParse(_bunniesPriceController.text) ?? 0.0);
      _pricingTypes.add(_bunniesPricingTypeController.text);
      _maxNumbers.add(int.tryParse(_bunniesSlotController.text) ?? 0);
    } else {
      int index = _petCategoryIds.indexOf(5);
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
          AsyncData(:final value) => SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
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
                          subtitle: Text("One capacity for dogs of any size."),
                          value: false,
                          groupValue: _separateBySize,
                          onChanged: (value) {
                            setState(() {
                              _separateBySize = value as bool;
                            });
                          },
                        ),
                        priceSlotInput(
                          !_separateBySize,
                          _allDogSizePriceController,
                          _allDogSizePricingTypeController,
                          _allDogSizeSlotController,
                        ),
                        RadioListTile(
                          title: Text("Separate by Size"),
                          subtitle: Text("Different capacities for each size."),
                          value: true,
                          groupValue: _separateBySize,
                          onChanged: (value) {
                            setState(() {
                              _separateBySize = value as bool;
                            });
                          },
                        ),
                        if (_separateBySize) ...[
                          buildSizedCheckbox(
                            "Small-Sized Breeds",
                            "0 - 5kg",
                            _acceptSmallDog,
                            (val) {
                              setState(() {
                                _acceptSmallDog = val ?? false;
                              });
                            },
                          ),
                          priceSlotInput(
                            _acceptSmallDog,
                            _smallDogPriceController,
                            _smallDogPricingTypeController,
                            _smallDogSlotController,
                          ),
                          buildSizedCheckbox(
                            "Medium-Sized Breeds",
                            "5 - 10kg",
                            _acceptMediumDog,
                            (val) {
                              setState(() {
                                _acceptMediumDog = val ?? false;
                              });
                            },
                          ),
                          priceSlotInput(
                            _acceptMediumDog,
                            _mediumDogPriceController,
                            _mediumDogPricingTypeController,
                            _mediumDogSlotController,
                          ),
                          buildSizedCheckbox(
                            "Large-Sized Breeds",
                            "10 - 15kg",
                            _acceptLargeDog,
                            (val) {
                              setState(() {
                                _acceptLargeDog = val ?? false;
                              });
                            },
                          ),
                          priceSlotInput(
                            _acceptLargeDog,
                            _largeDogPriceController,
                            _largeDogPricingTypeController,
                            _largeDogSlotController,
                          ),
                        ],
                      ],
                      SizedBox(height: 20),
                      Text("Others",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange)),
                      buildCheckboxTile("Accept cats?", _acceptCats, (value) {
                        setState(() {
                          _acceptCats = value!;
                        });
                      }),
                      priceSlotInput(
                        _acceptCats,
                        _catsPriceController,
                        _catsPricingTypeController,
                        _catsSlotController,
                      ),
                      buildCheckboxTile("Accept bunnies?", _acceptBunnies,
                          (value) {
                        setState(() {
                          _acceptBunnies = value!;
                        });
                      }),
                      priceSlotInput(
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
          _ => Center(child: CircularProgressIndicator()),
        });
  }

  // TODO: use AbsorbPointer to disable
  Widget priceSlotInput(
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
          child: TextField(
            controller: priceController,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: "Price",
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        Text("/"),
        Expanded(
            child: TextField(
          controller: pricingTypeController,
          enabled: enabled,
          decoration: InputDecoration(
            labelText: "",
          ),
        )),
        Expanded(
          child: TextField(
            controller: slotController,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: "Slot",
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget buildCheckboxTile(
      String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget buildSizedCheckbox(String title, String subtitle, bool val,
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
