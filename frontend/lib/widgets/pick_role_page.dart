import 'package:flutter/material.dart';
import 'package:frontend/widgets/create_pet_owner.dart';

class PickRolePage extends StatelessWidget {
  const PickRolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick a Role"),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8.0,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.pets,
                  color: Colors.white,
                ),
                label: const Text(
                  "Pet Owner",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                iconAlignment: IconAlignment.start,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const CreatePetOwnerPage()),
                  );
                },
              ),
            ),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.home_filled,
                  color: Colors.white,
                ),
                label: const Text(
                  "Pet Daycare Provider",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                iconAlignment: IconAlignment.start,
              ),
            ),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.healing_rounded,
                  color: Colors.white,
                ),
                label: const Text(
                  "Veterinarian",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                iconAlignment: IconAlignment.start,
              ),
            )
          ],
        ),
      ),
    );
  }
}
