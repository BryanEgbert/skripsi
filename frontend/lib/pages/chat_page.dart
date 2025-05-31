import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/chat_bubble.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/send_message.dart';
import 'package:frontend/pages/send_image_page.dart';
import 'package:frontend/provider/chat_tracker_provider.dart';
import 'package:frontend/provider/database_provider.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/utils/chat_websocket_channel.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/permission.dart';
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
  final _listScrollController = ScrollController();

  IOWebSocketChannel? channel;

  // List<ChatMessage> _totalMessages = [];

  bool _isSocketReady = false;

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      bool isAccessGranted = await ensureCameraPermission();
      if (!isAccessGranted) {
        return;
      }
    }
    final photo = await ImagePicker().pickImage(source: source);
    if (mounted) {
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (context) => SendImagePage(
              image: File(photo!.path),
              receiverId: widget.userId,
            ),
          ))
          .then(
            (_) => setState(
              () {
                // ref
                //     .read(chatMessagesProvider(widget.userId).future)
                //     .then((newData) {
                //   setState(() {
                //     _totalMessages = newData.data;
                //   });
                // });

                ref.invalidate(chatMessagesProvider);
              },
            ),
          );
    }
  }

  // void _fetchMessages() {
  //   ref.read(chatMessagesProvider(widget.userId).future).then((newData) {
  //     _totalMessages = newData.data;
  //   });
  // }

  void _setupWebSocket() {
    try {
      ChatWebsocketChannel().instance.then(
        (value) {
          channel = value;
          // _streamController.add(channel!.stream);
          channel!.sink.add(
            jsonEncode(
              SendMessage(
                updateRead: true,
                receiverId: widget.userId,
                message: "",
              ).toJson(),
            ),
          );
          // _webSocketSubscription = _streamController.stream.listen(
          //   (message) {
          //     log("[CHAT PAGE] new messages");
          //     var messages = ListData<ChatMessage>.fromJson(
          //         jsonDecode(message), ChatMessage.fromJson);
          //     if (messages.data.length > _messageCount) {
          //       log("[INFO] update read");
          //       channel!.sink.add(
          //         jsonEncode(
          //           SendMessage(
          //             updateRead: true,
          //             receiverId: widget.userId,
          //             message: "",
          //           ).toJson(),
          //         ),
          //       );
          //       _messageCount = messages.data.length;
          //     }
          //     _fetchMessages();
          //   },
          // );

          setState(() {
            _isSocketReady = true;
          });
        },
      );
    } catch (e) {
      // if (e.toString() == jwtExpired ||
      //     e.toString() == userDeleted && mounted) {
      //   Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => WelcomeWidget()),
      //     (route) => false,
      //   );
      // }
    }
  }

  @override
  void initState() {
    super.initState();
    _setupWebSocket();
    // _fetchMessages();
  }

  @override
  void dispose() {
    // _webSocketSubscription?.cancel();
    // channel?.sink.close();
    // ChatWebsocketChannel().sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final receiverUser = ref.watch(getUserByIdProvider(widget.userId));
    final myInfo = ref.watch(getTokenProvider);
    final chatTracker = ref.watch(chatTrackerProvider);

    final chatMessages = ref.watch(chatMessagesProvider(widget.userId));

    log("muInfo: $myInfo");

    handleError(myInfo, context);

    if (chatTracker.value ?? false) {
      setState(() {
        ref.invalidate(chatMessagesProvider);
        channel!.sink.add(
          jsonEncode(
            SendMessage(
              updateRead: true,
              receiverId: widget.userId,
              message: "",
            ).toJson(),
          ),
        );
      });
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.read(chatTrackerProvider.notifier).reset();
      });
    }

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _listScrollController
          .jumpTo(_listScrollController.position.maxScrollExtent);
    });
    // final chat = ref.watch(chatMessagesProvider(widget.userId));

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
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultCircleAvatar(imageUrl: value.imageUrl),
                Text(
                  value.name,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Constants.primaryTextColor
                        : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: _isSocketReady
                      ? ListView.builder(
                          controller: _listScrollController,
                          padding: EdgeInsets.all(8),
                          itemCount: chatMessages.value!.data.length,
                          itemBuilder: (context, index) {
                            var msg = chatMessages.value!.data[index];
                            log("message: $msg");

                            final dateTime =
                                DateTime.parse(msg.createdAt).toLocal();

                            final formatter =
                                DateFormat('EEE, dd MMM yyyy HH:mm');
                            final formattedDate = formatter.format(dateTime);

                            if (msg.type == "message") {
                              return ChatBubble(
                                msg: msg,
                                myInfo: myInfo,
                                formattedDate: formattedDate,
                              );
                            } else if (msg.type == "error") {
                              return Column(
                                children: [
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
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              formattedDate,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                ),
                Divider(),
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
                  child: Row(
                    spacing: 4,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PopupMenuButton(
                        icon: Icon(Icons.add),
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
                        ],
                      ),
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            labelText: "Message",
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (chatMessages.isLoading) return;
                          if (_textController.text.isNotEmpty) {
                            var sendMessage = jsonEncode(SendMessage(
                              receiverId: widget.userId,
                              message: _textController.text,
                            ).toJson());

                            channel!.sink.add(sendMessage);

                            _textController.clear();
                            // ref
                            //     .read(chatMessagesProvider(widget.userId)
                            //         .future)
                            //     .then((newData) {
                            //   setState(() {
                            //     _totalMessages = newData.data;
                            //   });
                            // });
                            ref.invalidate(chatMessagesProvider);
                          }
                        },
                        icon: !chatMessages.isLoading
                            ? Icon(
                                Icons.send_rounded,
                                color: Colors.orange[800],
                              )
                            : CircularProgressIndicator(
                                semanticsLabel: "sending message",
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
