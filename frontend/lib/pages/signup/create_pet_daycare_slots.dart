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
  bool _acceptDogs = false;
  bool _acceptSmallDog = false;
  bool _acceptMediumDog = false;
  bool _acceptLargeDog = false;

  bool _separateBySize = false;
  bool _acceptCats = false;
  bool _acceptBunnies = false;

  @override
  Widget build(BuildContext context) {
    final petCategory = ref.watch(petCategoryProvider);

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
                        priceSlotInput(!_separateBySize),
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
                          priceSlotInput(_acceptSmallDog),
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
                          priceSlotInput(_acceptMediumDog),
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
                          priceSlotInput(_acceptLargeDog),
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
                      priceSlotInput(_acceptCats),
                      buildCheckboxTile("Accept bunnies?", _acceptBunnies,
                          (value) {
                        setState(() {
                          _acceptBunnies = value!;
                        });
                      }),
                      priceSlotInput(_acceptBunnies),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CreatePetDaycareServices(),
                          ));
                        },
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
  Widget priceSlotInput(bool enabled) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Text("Rp."),
        Expanded(
          child: TextField(
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
          enabled: enabled,
          decoration: InputDecoration(
            labelText: "",
          ),
        )),
        Expanded(
          child: TextField(
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
