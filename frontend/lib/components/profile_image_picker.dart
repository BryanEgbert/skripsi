import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

class ProfileImagePicker extends StatefulWidget {
  final void Function()? onTap;
  final File? image;
  final String? imageUrl;
  const ProfileImagePicker({super.key, this.onTap, this.image, this.imageUrl});

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Badge(
            label: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Constants.primaryTextColor
                      : Colors.orange,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  child:
                      Icon(Icons.edit_outlined, color: Colors.white, size: 20),
                )),
            largeSize: 30,
            backgroundColor: Color(0XFFFFF8F0),
            offset: Offset(0, 80),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: widget.image != null || widget.imageUrl != null
                    ? DecorationImage(
                        image: widget.image != null
                            ? FileImage(widget.image!)
                            : NetworkImage(widget.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: Colors.grey[300],
              ),
              // child:
            ),
          ),
          // if (widget.image != null)
          //   Container(
          //     width: 40,
          //     height: 40,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: Colors.black54,
          //     ),
          //     child: Icon(
          //       Icons.edit,
          //       color: Colors.white,
          //       size: 24,
          //     ),
          //   ),
        ],
      ),
    );
  }
}
