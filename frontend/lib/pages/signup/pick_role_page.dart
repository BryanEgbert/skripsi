import 'package:flutter/material.dart';
import 'package:frontend/components/signup_guide_text.dart';
import 'package:frontend/pages/signup/create_user.dart';

class PickRolePage extends StatelessWidget {
  const PickRolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SignupGuideText(
              title: "Join Our Pet Daycare Community!",
              subtitle: "Choose your role to get started:",
            ),
            SizedBox(height: 56),
            displayRoleButtons(context)
          ],
        ),
      ),
    );
  }

  Column displayRoleButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFE68A00)),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const CreateUserPage(roleId: 1)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 26),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pet Owner",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Discover trusted pet daycares & chat with vets.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFF4A700)),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const CreateUserPage(roleId: 2)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 26),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pet Daycare Provider",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Connect with pet owners & grow your business.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const CreateUserPage(roleId: 3)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 26),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Veterinarian",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Provide expert care & guidance to pet owners.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
