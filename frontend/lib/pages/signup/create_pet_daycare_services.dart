import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/modals/select_lookup_modal.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/model/request/create_pet_daycare_request.dart';
import 'package:frontend/model/request/create_user_request.dart';
import 'package:frontend/pages/pet_daycare_home_page.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/category_provider.dart';
import 'package:frontend/utils/validator.dart';

class CreatePetDaycareServices extends ConsumerStatefulWidget {
  final CreateUserRequest createUserReq;
  final CreatePetDaycareRequest createPetDaycareReq;
  const CreatePetDaycareServices({
    super.key,
    required this.createUserReq,
    required this.createPetDaycareReq,
  });

  @override
  ConsumerState<CreatePetDaycareServices> createState() =>
      _CreatePetDaycareServicesState();
}

class _CreatePetDaycareServicesState
    extends ConsumerState<CreatePetDaycareServices> {
  final _formKey = GlobalKey<FormState>();

  final _dailyWalkController = TextEditingController();
  final _dailyPlaytimeController = TextEditingController();

  final _categoryFocusNode = FocusNode();

  bool _petVaccinationRequired = false;
  bool _groomingServiceProvided = false;
  bool _pickupServiceProvided = false;
  bool _foodProvided = false;

  int _dailyWalksId = 0;
  int _dailyPlaytimeId = 0;

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.createPetDaycareReq.foodProvided = _foodProvided;
    widget.createPetDaycareReq.groomingAvailable = _groomingServiceProvided;
    widget.createPetDaycareReq.mustBeVaccinated = _petVaccinationRequired;
    widget.createPetDaycareReq.hasPickupService = _pickupServiceProvided;
    widget.createPetDaycareReq.dailyWalksId = _dailyWalksId;
    widget.createPetDaycareReq.dailyPlaytimeId = _dailyPlaytimeId;

    ref.read(authProvider.notifier).createPetDaycareProvider(
        widget.createUserReq, widget.createPetDaycareReq);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => PetDaycareHomePage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    if (auth.hasError && !auth.hasValue && !auth.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        var snackbar = SnackBar(
          key: Key("error-message"),
          content: Text(auth.error.toString()),
          backgroundColor: Colors.red,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      });
    }

    if (auth.hasValue && !auth.hasError && !auth.isLoading) {
      if (auth.value != null) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => PetDaycareHomePage(),
            ),
            (route) => false,
          );
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Configure Your Services",
          style: TextStyle(color: Colors.orange),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: Container(
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
              title: Text("Grooming Required"),
              value: _groomingServiceProvided,
              onChanged: (value) {
                setState(() {
                  _groomingServiceProvided = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: Text("Pickup Required"),
              value: _pickupServiceProvided,
              onChanged: (value) {
                setState(() {
                  _pickupServiceProvided = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: Text("Food Required"),
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
            // TODO: update value on subtitle
            // additionalServicesListTiles(
            //   context,
            //   dailyWalks,
            //   dailyPlaytime,
            //   (value) {
            //     setState(() {
            //       _dailyWalksId = value ?? 0;
            //     });
            //   },
            //   (value) {
            //     setState(() {
            //       _dailyPlaytimeId = value ?? 0;
            //     });
            //   },
            // ),

            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    TextFormField(
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
                            builder: (context) => SelectLookupModal(
                                LookupCategory.dailyPlaytime));

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
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(
                "Next",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget additionalServicesListTiles(
      BuildContext context,
      AsyncValue<List<Lookup>> dailyWalksValue,
      AsyncValue<List<Lookup>> dailyPlaytimeValue,
      void Function(int?)? onDailyWalkChanged,
      void Function(int?)? onDailyPlaytimeChanged) {
    return Column(
      children: [
        ListTile(
          title: Text("Daily Walks"),
          subtitle: _dailyWalksId > 0
              ? Text(dailyWalksValue.value![_dailyWalksId - 1].name)
              : null,
          trailing: Icon(Icons.navigate_next_rounded),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => selectDailyWalksCategoryModal(
                  dailyWalksValue, onDailyWalkChanged),
            );
          },
        ),
        ListTile(
          title: Text("Daily Playtime"),
          subtitle: _dailyPlaytimeId > 0
              ? Text(dailyPlaytimeValue.value![_dailyPlaytimeId - 1].name)
              : null,
          trailing: Icon(Icons.navigate_next_rounded),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => selectDailyPlaytimeCategoryModal(
                  dailyPlaytimeValue, onDailyPlaytimeChanged),
            );
          },
        ),
      ],
    );
  }

  Widget selectDailyWalksCategoryModal(
      AsyncValue<List<Lookup>> category, void Function(int?)? func) {
    return switch (category) {
      AsyncData(:final value) => StatefulBuilder(builder: (context, setState) {
          return ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                return RadioListTile(
                  title: Text(value[index].name),
                  value: value[index].id,
                  groupValue: _dailyWalksId,
                  onChanged: (value) {
                    setState(
                      () {
                        _dailyWalksId = value ?? 0;
                        func!(value);
                      },
                    );
                  },
                );
              });
        }),
      AsyncError() => SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Center(child: const Text("Something's wrong")),
        ),
      _ => SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: const CircularProgressIndicator(),
          ),
        ),
    };
  }

  Widget selectDailyPlaytimeCategoryModal(
      AsyncValue<List<Lookup>> category, void Function(int?)? func) {
    return switch (category) {
      AsyncData(:final value) => StatefulBuilder(builder: (context, setState) {
          return ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                return RadioListTile(
                  title: Text(value[index].name),
                  value: value[index].id,
                  groupValue: _dailyPlaytimeId,
                  onChanged: (value) {
                    setState(
                      () {
                        _dailyPlaytimeId = value ?? 0;
                        func!(value);
                      },
                    );
                  },
                );
              });
        }),
      AsyncError() => SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Center(child: const Text("Something's wrong")),
        ),
      _ => SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: const CircularProgressIndicator(),
          ),
        ),
    };
  }
}
