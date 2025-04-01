import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/provider/category_provider.dart';

class CreatePetDaycareServices extends ConsumerStatefulWidget {
  const CreatePetDaycareServices({super.key});

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

  @override
  Widget build(BuildContext context) {
    // TODO: Change to daily walks and daily playtime to show modal
    final dailyWalks = ref.watch(dailyWalksProvider);
    final dailyPlaytime = ref.watch(dailyPlaytimesProvider);

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
            additionalServicesListTiles(context, dailyWalks, dailyPlaytime),
            SizedBox(height: 24),
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
          ],
        ),
      ),
    );
  }

  Widget additionalServicesListTiles(
      BuildContext context,
      AsyncValue<List<Lookup>> dailyWalksValue,
      AsyncValue<List<Lookup>> dailyPlaytimeValue) {
    return Column(
      children: [
        ListTile(
          title: Text("Daily Walks"),
          trailing: Icon(Icons.navigate_next_rounded),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => selectCategoryModal(dailyWalksValue),
            );
          },
        ),
        ListTile(
          title: Text("Daily Playtime"),
          trailing: Icon(Icons.navigate_next_rounded),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => selectCategoryModal(dailyPlaytimeValue),
            );
          },
        ),
      ],
    );
  }

  Widget selectCategoryModal(AsyncValue<List<Lookup>> category) {
    return StatefulBuilder(
      builder: (context, setState) {
        return switch (category) {
          AsyncData(:final value) => ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                return RadioListTile(
                    title: Text(value[index].name),
                    value: value[index].id,
                    groupValue: _dailyWalksId,
                    onChanged: (int? v) {
                      setState(() {
                        _dailyWalksId = v!;
                      });
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
      },
    );
  }
}
