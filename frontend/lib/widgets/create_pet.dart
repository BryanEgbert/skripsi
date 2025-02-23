import 'package:flutter/material.dart';
import 'package:frontend/widgets/select_pet_size_modal.dart';
import 'package:frontend/widgets/select_species_modal.dart';

class CreatePetPage extends StatefulWidget {
  const CreatePetPage({super.key});

  @override
  State<CreatePetPage> createState() => _CreatePetPageState();
}

class _CreatePetPageState extends State<CreatePetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fill Pet Info"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              IconButton.filled(
                key: Key("image-picker"),
                onPressed: () {},
                style: IconButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(32),
                ),
                icon: Icon(
                  Icons.add_a_photo_rounded,
                  size: 42,
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
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
              selectCategory(
                  context, SelectSpeciesModal(), "Choose pet species"),
              selectCategory(context, SelectPetSizeModal(), "Choose pet size"),
              SizedBox(
                height: 16,
              ),
              FilledButton(
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => CreatePetPage(),
                  //     ));
                },
                child: const Text("Create Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell selectCategory(BuildContext context, Widget route, String labelText) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(context: context, builder: (context) => route);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(labelText),
          Icon(Icons.arrow_forward_ios_rounded),
        ],
      ),
    );
  }
}
