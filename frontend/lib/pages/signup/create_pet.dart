import 'package:flutter/material.dart';
import 'package:frontend/components/modals/select_pet_size_modal.dart';
import 'package:frontend/components/modals/select_species_modal.dart';
import 'package:frontend/components/pet_details_form.dart';
import 'package:frontend/components/signup_guide_text.dart';
import 'package:frontend/pages/home.dart';

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SignupGuideText(
                  title: "Let's Set Up Your Account",
                  subtitle: "Enter your pet details to continue",
                ),
                SizedBox(height: 56),
                PetDetailsForm(
                  onSubmit: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HomeWidget(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
