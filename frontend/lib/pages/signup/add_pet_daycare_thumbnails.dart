import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/components/signup_guide_text.dart';
import 'package:frontend/model/request/create_pet_daycare_request.dart';
import 'package:frontend/model/request/create_user_request.dart';
import 'package:frontend/pages/signup/create_pet_daycare_slots.dart';
import 'package:image_picker/image_picker.dart';

class AddPetDaycareThumbnails extends StatefulWidget {
  final CreateUserRequest createUserReq;
  final CreatePetDaycareRequest createPetDaycareReq;
  const AddPetDaycareThumbnails(
      {super.key,
      required this.createUserReq,
      required this.createPetDaycareReq});

  @override
  State<AddPetDaycareThumbnails> createState() =>
      _AddPetDaycareThumbnailsState();
}

class _AddPetDaycareThumbnailsState extends State<AddPetDaycareThumbnails> {
  final List<File?> _images = List.filled(9, null);
  String? _errorText;

  Future<void> _pickImage(int index) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images[index] = File(pickedFile.path);
      });
    }
  }

  void _deleteImage(int index) {
    setState(() {
      _images[index] = null;
    });
  }

  void _submitForm() {
    widget.createPetDaycareReq.thumbnails = _images.whereType<File>().toList();
    if (widget.createPetDaycareReq.thumbnails.isEmpty) {
      setState(() {
        _errorText = "Must contains at least one image";
      });
      return;
    }

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CreatePetDaycareSlots(
        createUserReq: widget.createUserReq,
        createPetDaycareReq: widget.createPetDaycareReq,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (_errorText != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        var snackbar = SnackBar(
          key: Key("error-message"),
          content: Text(_errorText!),
          backgroundColor: Colors.red,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        _errorText = null;
      });
    }

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SignupGuideText(
              title: "Let's Set Up Your Account",
              subtitle: "Add images of your pet daycare (min. 1 image)",
            ),
            SizedBox(height: 56),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 9,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _pickImage(index),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300],
                      image: _images[index] != null
                          ? DecorationImage(
                              image: FileImage(_images[index]!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _images[index] == null
                        ? Icon(Icons.image, color: Colors.black54, size: 32)
                        : Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black45,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    index == 0
                                        ? Icons.edit
                                        : Icons
                                            .delete, // First image = edit, others = delete
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (index == 0) {
                                      _pickImage(index); // Edit first image
                                    } else {
                                      _deleteImage(
                                          index); // Delete other images
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
