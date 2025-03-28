import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/modals/select_species_modal.dart';

class PetDetailsForm extends ConsumerStatefulWidget {
  final VoidCallback onSubmit;
  const PetDetailsForm({
    super.key,
    required this.onSubmit,
  });

  @override
  ConsumerState<PetDetailsForm> createState() => _PetDetailsFormState();
}

class _PetDetailsFormState extends ConsumerState<PetDetailsForm> {
  bool isNeutered = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          IconButton.filled(
            key: Key("image-picker"),
            onPressed: () {},
            style: IconButton.styleFrom(
              shape: CircleBorder(),
              minimumSize: Size(100, 100),
            ),
            icon: Icon(
              Icons.add_a_photo_rounded,
              size: 32,
            ),
          ),
          TextFormField(
            key: Key("name-input"),
            // controller: _passwordEditingController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              labelText: "Name",
            ),
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context, builder: (context) => SelectSpeciesModal());
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Choose Your Pet's Type & Size"),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
                Divider(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Spayed/Neutered"),
                Checkbox(
                  value: isNeutered,
                  onChanged: (value) {
                    setState(() {
                      isNeutered = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: widget.onSubmit,
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }
}
