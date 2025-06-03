import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/modals/select_lookup_modal.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/model/request/create_pet_daycare_request.dart';
import 'package:frontend/model/request/create_user_request.dart';
import 'package:frontend/pages/pet_daycare_home_page.dart';
import 'package:frontend/provider/auth_provider.dart';
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
    if (ref.read(authProvider).isLoading) return;
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
                color: Theme.of(context).brightness == Brightness.light
                    ? Constants.primaryTextColor
                    : Colors.orange,
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
              "Additional Services",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.light
                    ? Constants.primaryTextColor
                    : Colors.orange,
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
              title: Text("In-House Food Provided"),
              value: _foodProvided,
              onChanged: (value) {
                setState(() {
                  _foodProvided = value ?? false;
                });
              },
            ),
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
              child: !auth.isLoading
                  ? Text(
                      "Create My Account",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )
                  : CircularProgressIndicator(
                      color: Colors.white,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
