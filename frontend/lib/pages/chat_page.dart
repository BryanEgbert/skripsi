import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/chat_message.dart';
import 'package:frontend/model/error_handler/error_handler.dart';
import 'package:frontend/model/send_message.dart';
import 'package:frontend/pages/send_image_page.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/provider/database_provider.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/utils/chat_websocket_channel.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:web_socket_channel/io.dart';

class ChatPage extends ConsumerStatefulWidget {
  final int userId;
  const ChatPage({super.key, required this.userId});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _textController = TextEditingController();
  IOWebSocketChannel? channel;
  SendMessage? _sendMessage;

  Future<void> _pickImage(ImageSource source) async {
    final photo = await ImagePicker().pickImage(source: source);
    if (mounted) {
      _sendMessage = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SendImagePage(image: File(photo!.path)),
      ));

      if (_sendMessage != null) {
        _sendMessage!.receiverId = widget.userId;
        channel!.sink.add(_sendMessage);

        _sendMessage = null;
      }
    }
  }

  Future<void> _setupWebSocket() async {
    try {
      channel = await ChatWebsocketChannel.instance;
    } catch (e) {
      if (e.toString() == jwtExpired && mounted) {
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
  Widget build(BuildContext context) {
    final receiverUser = ref.watch(getUserByIdProvider(widget.userId));
    final myInfo = ref.watch(getTokenProvider);

    return switch (receiverUser) {
      AsyncError(:final error) => ErrorText(
          errorText: error.toString(),
          onRefresh: () =>
              ref.refresh(getUserByIdProvider(widget.userId).future)),
      AsyncData(:final value) => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back_ios),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultCircleAvatar(imageUrl: value.imageUrl),
                Text(value.name),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: channel!.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var msg = ChatMessage.fromJson(jsonDecode(snapshot.data));

                      final dateTime = DateTime.parse(msg.createdAt);
                      final formatter = DateFormat('EEE, dd MMM yyyy');
                      final formattedDate = formatter.format(dateTime);

                      if (msg.type == "message") {
                        return Row(
                          mainAxisAlignment:
                              (msg.senderId == myInfo.value!.userId)
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                          children: [
                            if (msg.senderId == myInfo.value!.userId)
                              Text(formattedDate),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: (msg.senderId == myInfo.value!.userId)
                                    ? Colors.orange[300]
                                    : Constants.secondaryBackgroundColor,
                              ),
                              child: Column(
                                children: [
                                  if (msg.imageUrl != null)
                                    Image.network(msg.imageUrl!),
                                  Text(
                                    msg.message,
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            if (msg.senderId != myInfo.value!.userId)
                              Text(formattedDate),
                          ],
                        );
                      } else if (msg.type == "error") {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  (msg.senderId == myInfo.value!.userId)
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              children: [
                                if (msg.senderId == myInfo.value!.userId)
                                  Text(formattedDate),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: (msg.senderId ==
                                            myInfo.value!.userId)
                                        ? Colors.orange[300]
                                        : Constants.secondaryBackgroundColor,
                                  ),
                                  child: Column(
                                    children: [
                                      if (msg.imageUrl != null)
                                        Image.network(msg.imageUrl!),
                                      Text(
                                        msg.message,
                                        style: TextStyle(
                                          color: Colors.black87,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                if (msg.senderId != myInfo.value!.userId)
                                  Text(formattedDate),
                              ],
                            ),
                            Text(
                              "Failed to send message",
                              style: TextStyle(color: Colors.red[800]),
                            ),
                          ],
                        );
                      } else {
                        return SizedBox();
                      }
                    } else if (snapshot.hasError) {
                      var snackbar = SnackBar(
                        key: Key("error-message"),
                        content: Text(
                          snapshot.error.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red[800],
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }

                    return SizedBox();
                  },
                ),
              ),
              Container(
                color: Constants.secondaryBackgroundColor,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      decoration: InputDecoration(
                        suffix: PopupMenuButton(
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Text("Take Photo"),
                                    onTap: () {
                                      _pickImage(ImageSource.camera);
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: Text("Gallery"),
                                    onTap: () {
                                      _pickImage(ImageSource.gallery);
                                    },
                                  ),
                                ]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: "Message",
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          if (_textController.text.isNotEmpty) {
                            channel!.sink.add(SendMessage(
                              receiverId: widget.userId,
                              message: _textController.text,
                            ));

                            _textController.text = "";
                          }
                        },
                        icon: Icon(
                          Icons.send_rounded,
                          color: Colors.orange[800],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      _ => Center(
          child: CircularProgressIndicator(
            semanticsLabel: "Fetching user data",
            color: Colors.orange,
          ),
        ),
    };
  }
}
