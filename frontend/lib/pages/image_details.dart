import 'package:flutter/material.dart';

class ImageDetailsPage extends StatelessWidget {
  final String imageUrl;
  const ImageDetailsPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
