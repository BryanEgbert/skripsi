import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frontend/model/send_message.dart';

class SendImagePage extends StatefulWidget {
  final File image;
  const SendImagePage({super.key, required this.image});

  @override
  State<SendImagePage> createState() => _SendImagePageState();
}

class _SendImagePageState extends State<SendImagePage> {
  final _textController = TextEditingController();
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        children: [
          Expanded(child: Image.file(widget.image)),
          Row(
            children: [
              TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: InputDecoration(
                  enabled: _isUploading == false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: "Message",
                ),
              ),
              IconButton(
                onPressed: () async {
                  setState(() {
                    _isUploading = true;
                  });

                  if (_isUploading) return;

                  String fileName =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  Reference storageReference =
                      FirebaseStorage.instance.ref().child('images/$fileName');
                  UploadTask uploadTask =
                      storageReference.putFile(File(widget.image.path));
                  String imageUrl =
                      await (await uploadTask).ref.getDownloadURL();

                  setState(() {
                    _isUploading = false;
                  });

                  if (context.mounted) {
                    Navigator.of(context).pop(SendMessage(
                      receiverId: 0,
                      message: _textController.text,
                      imageUrl: imageUrl,
                    ));
                  }
                },
                icon: Icon(
                  Icons.send_rounded,
                  color: Colors.orange[700],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
