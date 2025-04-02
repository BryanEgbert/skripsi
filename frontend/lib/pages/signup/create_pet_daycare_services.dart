import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/model/request/create_pet_daycare_request.dart';
import 'package:frontend/model/request/create_user_request.dart';
import 'package:frontend/pages/pet_daycare_home_page.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/category_provider.dart';
import 'package:frontend/provider/list_data_provider.dart';

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
  bool _petVaccinationRequired = false;
  bool _groomingServiceProvided = false;
  bool _pickupServiceProvided = false;
  bool _foodProvided = false;

  int _dailyWalksId = 0;
  int _dailyPlaytimeId = 0;

  // TODO: validate if _dailyWalksId and daily playtimeId is not 0
  void _submitForm() {
    widget.createPetDaycareReq.foodProvided = _foodProvided;
    widget.createPetDaycareReq.groomingAvailable = _groomingServiceProvided;
    widget.createPetDaycareReq.mustBeVaccinated = _petVaccinationRequired;
    widget.createPetDaycareReq.hasPickupService = _pickupServiceProvided;
    widget.createPetDaycareReq.dailyWalksId = _dailyWalksId;
    widget.createPetDaycareReq.dailyPlaytimeId = _dailyPlaytimeId;
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    final dailyWalks = ref.watch(dailyWalksProvider);
    final dailyPlaytime = ref.watch(dailyPlaytimesProvider);

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
            additionalServicesListTiles(
              context,
              dailyWalks,
              dailyPlaytime,
              (value) {
                setState(() {
                  _dailyWalksId = value ?? 0;
                });
              },
              (value) {
                setState(() {
                  _dailyPlaytimeId = value ?? 0;
                });
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _submitForm();

                log("[INFO] ${widget.createPetDaycareReq}");

                ref.read(authProvider.notifier).createPetDaycareProvider(
                    widget.createUserReq, widget.createPetDaycareReq);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => PetDaycareHomePage(),
                  ),
                  (route) => false,
                );
              },
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
