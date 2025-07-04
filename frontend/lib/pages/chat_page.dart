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
import 'package:frontend/l10n/app_localizations.dart';
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

class _ChatPageState extends ConsumerState<ChatPage>
    with WidgetsBindingObserver {
  final _textController = TextEditingController();
  final _listScrollController = ScrollController();

  IOWebSocketChannel? channel;

  // List<ChatMessage> _totalMessages = [];

  bool _isSocketReady = false;

  Future<void> _pickImage(ImageSource source) async {
    if (!mounted) return;

    if (source == ImageSource.camera) {
      bool isAccessGranted = await ensureCameraPermission();
      if (!isAccessGranted) {
        return;
      }
    }
    final photo = await ImagePicker().pickImage(source: source);
    if (photo == null) return;
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => SendImagePage(
        image: File(photo.path),
        receiverId: widget.userId,
      ),
    ))
        .then(
      (_) {
        if (!mounted) return;
        ref.invalidate(chatMessagesProvider);
      },
    );
  }

  void _setupWebSocket() {
    try {
      ChatWebsocketChannel().instance.then(
        (value) {
          if (!mounted) return;
          channel = value;
          // _streamController.add(channel!.stream);
          channel?.sink.add(
            jsonEncode(
              SendMessage(
                updateRead: true,
                receiverId: widget.userId,
                message: "",
              ).toJson(),
            ),
          );

          setState(() {
            _isSocketReady = true;
          });
        },
      );
    } catch (e) {
      if (!mounted) return;
      handleError(AsyncError(e.toString(), StackTrace.current), context);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupWebSocket();
    // _fetchMessages();
  }

  @override
  void dispose() {
    // channel?.sink.close();
    channel = null;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("[APP LIFECYCLE STATE] state changed: $state", name: "chat_page.dart");
    if (state == AppLifecycleState.resumed) {
      _setupWebSocket();
    } else if (state == AppLifecycleState.paused) {
      channel?.sink.close();
      channel = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final receiverUser = ref.watch(getUserByIdProvider(widget.userId));
    final myInfo = ref.watch(getTokenProvider);
    final chatTracker = ref.watch(chatTrackerProvider);

    final chatMessages = ref.watch(chatMessagesProvider(widget.userId));

    handleError(myInfo, context);

    if (chatTracker.value ?? false) {
      setState(() {
        ref.invalidate(chatMessagesProvider);
        channel?.sink.add(
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

    if (chatMessages is AsyncData && _listScrollController.hasClients) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        _listScrollController
            .jumpTo(_listScrollController.position.maxScrollExtent);
      });
    }
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
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).brightness == Brightness.light
                    ? Constants.primaryTextColor
                    : Colors.orange,
              ),
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
                  child: _isSocketReady && chatMessages.hasValue
                      ? ListView.builder(
                          controller: _listScrollController,
                          padding: EdgeInsets.all(8),
                          itemCount: chatMessages.value!.data.length,
                          itemBuilder: (context, index) {
                            var msg = chatMessages.value!.data[index];

                            // log("msg: $msg");
                            final dateTime =
                                DateTime.parse(msg.createdAt).toLocal();

                            final formatter = DateFormat(
                                'EEE, dd MMM yyyy HH:mm',
                                Localizations.localeOf(context)
                                    .toLanguageTag());
                            final formattedDate = formatter.format(dateTime);

                            return ChatBubble(
                              msg: msg,
                              myInfo: myInfo,
                              formattedDate: formattedDate,
                            );
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
                            child:
                                Text(AppLocalizations.of(context)!.takePhoto),
                            onTap: () {
                              _pickImage(ImageSource.camera);
                            },
                          ),
                          PopupMenuItem(
                            child:
                                Text(AppLocalizations.of(context)!.sendImage),
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
                            ref.invalidate(chatMessagesProvider);
                            ref
                                .read(chatTrackerProvider.notifier)
                                .shouldReload();
                          }
                        },
                        icon: !chatMessages.isLoading
                            ? Icon(
                                Icons.send_rounded,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Constants.primaryTextColor
                                    : Colors.orange,
                              )
                            : CircularProgressIndicator(
                                semanticsLabel: "sending message",
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Constants.primaryTextColor
                                    : Colors.orange,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      _ => Container(
          color: Theme.of(context).brightness == Brightness.light
              ? Constants.backgroundColor
              : Colors.black87,
          child: Center(
            child: CircularProgressIndicator(
              semanticsLabel: "Fetching user data",
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.primaryTextColor
                  : Colors.orange,
            ),
          ),
        ),
    };
  }
}
