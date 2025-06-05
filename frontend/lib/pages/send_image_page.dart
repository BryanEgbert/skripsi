import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/send_message.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/provider/image_provider.dart';
import 'package:frontend/services/localization_service.dart';
import 'package:frontend/utils/chat_websocket_channel.dart';
import 'package:web_socket_channel/io.dart';

class SendImagePage extends ConsumerStatefulWidget {
  final int receiverId;
  final File image;
  const SendImagePage(
      {super.key, required this.image, required this.receiverId});

  @override
  ConsumerState<SendImagePage> createState() => _SendImagePageState();
}

class _SendImagePageState extends ConsumerState<SendImagePage> {
  final _textController = TextEditingController();
  IOWebSocketChannel? _channel;

  void _setupWebSocket() {
    try {
      ChatWebsocketChannel().instance.then(
        (value) {
          _channel = value;
        },
      );
    } catch (e) {
      if (e.toString() == LocalizationService().jwtExpired && mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => WelcomeWidget()),
          (route) => false,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _setupWebSocket();
  }

  @override
  void dispose() {
    // log("[SEND IMAGE PAGE] dispose");
    // _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageState = ref.watch(imageStateProvider);

    if (imageState.hasError &&
        (imageState.valueOrNull == null) &&
        !imageState.isLoading) {
      log("send image err");
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        var snackbar = SnackBar(
          key: Key("error-message"),
          content: Text(
            imageState.error.toString(),
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red[800],
        );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);

        if (imageState.error.toString() == LocalizationService().jwtExpired ||
            imageState.error.toString() == LocalizationService().userDeleted) {
          WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => WelcomeWidget(),
                ),
                (route) => false,
              );
            },
          );
        }
      });
    } else if (!imageState.hasError &&
        !imageState.isLoading &&
        imageState.hasValue) {
      ChatWebsocketChannel().instance.then(
        (value) {
          _channel = value;
          _channel!.sink.add(jsonEncode(
            SendMessage(
              receiverId: widget.receiverId,
              message: _textController.text,
              imageUrl: imageState.value!.imageUrl,
            ).toJson(),
          ));

          if (!mounted) return;
          Navigator.of(context).pop();
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Image.file(widget.image)),
            Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      minLines: 1,
                      maxLines: 3,
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        enabled: imageState.isLoading == false,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: "Message",
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (imageState.isLoading) return;

                      // String fileName =
                      //     DateTime.now().millisecondsSinceEpoch.toString();
                      // Reference storageReference = FirebaseStorage.instance
                      //     .ref()
                      //     .child('images/$fileName');
                      // UploadTask uploadTask =
                      //     storageReference.putFile(File(widget.image.path));
                      // String imageUrl =
                      //     await (await uploadTask).ref.getDownloadURL();
                      ref
                          .read(imageStateProvider.notifier)
                          .upload(widget.image);
                    },
                    icon: (!imageState.isLoading)
                        ? Icon(
                            Icons.send_rounded,
                            color: Colors.orange[700],
                          )
                        : CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
