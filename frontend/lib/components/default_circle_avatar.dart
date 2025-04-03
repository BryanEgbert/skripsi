import 'package:flutter/material.dart';

class DefaultCircleAvatar extends StatelessWidget {
  const DefaultCircleAvatar({
    super.key,
    required this.imageUrl,
    this.iconSize,
    this.circleAvatarRadius,
  });

  final String imageUrl;
  final double? iconSize, circleAvatarRadius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: circleAvatarRadius,
      backgroundImage: NetworkImage(
        imageUrl.replaceFirst(
            RegExp(r'localhost:8080'), "http://10.0.2.2:8080"),
      ),
      backgroundColor: Colors.grey[300],
      onBackgroundImageError: (exception, stackTrace) {},
      child: imageUrl.isEmpty
          ? Icon(
              Icons.hide_image,
              size: iconSize,
            )
          : null,
    );
  }
}
