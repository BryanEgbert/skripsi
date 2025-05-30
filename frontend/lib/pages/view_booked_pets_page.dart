import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/model/chat_message.dart';
import 'package:frontend/model/pet.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/pages/chat_page.dart';
import 'package:frontend/pages/details/pet_details_page.dart';
import 'package:frontend/pages/send_image_page.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/message_tracker_provider.dart';
import 'package:frontend/utils/permission.dart';
import 'package:image_picker/image_picker.dart';

class ViewBookedPetsPage extends ConsumerStatefulWidget {
  // final IOWebSocketChannel channel;
  final List<ChatMessage> messages;
  const ViewBookedPetsPage(this.messages, {super.key});

  @override
  ConsumerState<ViewBookedPetsPage> createState() => _ViewBookedPetsPageState();
}

class _ViewBookedPetsPageState extends ConsumerState<ViewBookedPetsPage> {
  final ScrollController _scrollPetController = ScrollController();
  final ScrollController _scrollPetOwnerController = ScrollController();

  // IOWebSocketChannel? _channel;

  List<Pet> _petRecords = [];
  List<User> _bookedPetRecords = [];
  final int _pageSize = 10;

  int _lastId = 0;
  int _page = 1;
  bool _isFetching = false;
  bool _hasMoreData = true;
  String? _error;

  Future<void> _navigateToChatPage(int userId) async {
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ChatPage(userId: userId)));
    ref.read(petDaycareChatListTrackerProvider.notifier).shouldReload();
  }

  void _onScroll() {
    if (_scrollPetController.position.pixels >=
            _scrollPetController.position.maxScrollExtent - 200 &&
        !_isFetching) {
      _fetchMoreData(0);
    }
  }

  void _onPetOwnerScroll() {
    if (_scrollPetOwnerController.position.pixels >=
            _scrollPetOwnerController.position.maxScrollExtent - 200 &&
        !_isFetching) {
      _fetchMoreData(1);
    }
  }

  void _fetchMoreData(int index) {
    if (!_hasMoreData) return; // Stop fetching if no more data

    setState(() {
      _isFetching = true;
      _error = null;
    });

    if (index == 0) {
      ref.read(bookedPetsProvider(_lastId, _pageSize).future).then((newData) {
        if (newData.data.isNotEmpty) {
          setState(() {
            _petRecords.addAll(newData.data);
            _lastId = newData.data.last.id;
          });
        } else {
          setState(() {
            _hasMoreData = false;
          });
        }
      }).catchError((e) {
        // _error = e as String;
        _error = e;
        log("[INFO] error: $e");
      }).whenComplete(() => setState(() => _isFetching = false));
    } else {
      ref.read(bookedPetOwnerProvider(_page, _pageSize).future).then((newData) {
        if (newData.data.isNotEmpty) {
          setState(() {
            _bookedPetRecords.addAll(newData.data);
            _lastId = newData.data.last.id;
          });
        } else {
          setState(() {
            _hasMoreData = false;
          });
        }
      }).catchError((e) {
        // _error = e as String;
        _error = e;
        log("[INFO] error: $e");
      }).whenComplete(() => setState(() => _isFetching = false));
    }
  }

  // void _setupWebSocket() {
  //   try {
  //     ChatWebsocketChannel().instance.then(
  //       (value) {
  //         _channel = value;
  //         log("channel: ${_channel!.stream.toString()}");
  //       },
  //     );
  //   } catch (e) {
  //     if (e.toString() == jwtExpired && mounted) {
  //       Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (context) => WelcomeWidget()),
  //         (route) => false,
  //       );
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();

    _scrollPetController.addListener(_onScroll);
    _scrollPetOwnerController.addListener(_onPetOwnerScroll);

    // _setupWebSocket();

    _fetchMoreData(0);
    _fetchMoreData(1);
  }

  @override
  void dispose() {
    _scrollPetController.dispose();
    // _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("[VIEW BOOKED PETS] build");
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Booked Pets",
            style: TextStyle(color: Colors.orange),
          ),
          actions: appBarActions(),
          bottom: TabBar(tabs: [
            Tab(
              icon: Icon(Icons.pets_rounded),
              text: "Sort by Pets",
            ),
            Tab(
              icon: Icon(Icons.person_rounded),
              text: "Sort by Pet Owners",
            ),
          ]),
        ),
        body: TabBarView(children: [
          _buildViewByPets(widget.messages),
          _buildViewByPetOwners(widget.messages),
        ]),
      ),
    );
  }

  Widget _buildViewByPetOwners(List<ChatMessage> messages) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        _bookedPetRecords = [];
        _page = 1;
        _fetchMoreData(1);
      },
      child: (_isFetching && _petRecords.isEmpty)
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.orange,
            ))
          : (_error == null)
              ? (_petRecords.isEmpty)
                  ? ErrorText(
                      errorText: "There are no booked pet owners",
                      onRefresh: () async {
                        _bookedPetRecords = [];
                        _page = 1;
                        _fetchMoreData(1);
                      },
                    )
                  : ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: _scrollPetOwnerController,
                      itemCount: _bookedPetRecords.length + 1,
                      itemBuilder: (context, index) {
                        if (index < _bookedPetRecords.length) {
                          return ListTile(
                            leading: DefaultCircleAvatar(
                                imageUrl: _bookedPetRecords[index].imageUrl),
                            title: Text(_bookedPetRecords[index].name),
                            titleTextStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                            trailing: Badge.count(
                              count: messages.length,
                              isLabelVisible: messages.isNotEmpty,
                              child: IconButton(
                                onPressed: () async {
                                  await _navigateToChatPage(
                                      _bookedPetRecords[index].id);
                                },
                                icon: Icon(
                                  Icons.chat_rounded,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          );
                        } else {
                          if (_isFetching) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: Colors.orange,
                            ));
                          }

                          return SizedBox();
                        }
                      },
                    )
              : ErrorText(
                  errorText: _error!,
                  onRefresh: () async {
                    _bookedPetRecords = [];
                    _page = 1;
                    _fetchMoreData(1);
                  },
                ),
    );
  }

  Widget _buildViewByPets(List<ChatMessage> messages) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        _petRecords = [];
        _lastId = 0;
        _fetchMoreData(0);
      },
      child: (_isFetching && _petRecords.isEmpty)
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.orange,
            ))
          : (_error == null)
              ? (_petRecords.isEmpty)
                  ? ErrorText(
                      errorText: "There are no booked pets",
                      onRefresh: () async {
                        _petRecords = [];
                        _lastId = 0;
                        _fetchMoreData(0);
                      },
                    )
                  : _buildPetsListView(messages)
              : ErrorText(
                  errorText: _error!,
                  onRefresh: () async {
                    _petRecords = [];
                    _lastId = 0;
                    _fetchMoreData(0);
                  },
                ),
    );
  }

  Widget _buildPetsListView(List<ChatMessage> messages) {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      controller: _scrollPetController,
      itemCount: _petRecords.length + 1,
      itemBuilder: (context, index) {
        if (index < _petRecords.length) {
          return _buildListTile(context, _petRecords[index], messages);
        } else {
          if (_isFetching) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.orange,
            ));
          }

          return SizedBox();
        }
      },
    );
  }

  Widget _buildListTile(
      BuildContext context, Pet item, List<ChatMessage> messages) {
    return ListTile(
      leading: DefaultCircleAvatar(imageUrl: item.imageUrl ?? ""),
      title: Text(item.name),
      subtitle: Text(
        "Pet category: ${item.petCategory.name}\nStatus: ${item.status}\nOwner: ${item.owner.name}",
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white70,
        ),
      ),
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.orange,
      ),
      subtitleTextStyle: TextStyle(fontSize: 14, color: Colors.black),
      trailing: Badge.count(
        count: messages.length,
        isLabelVisible: messages.isNotEmpty,
        child: PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text("Log Pet Activity"),
                onTap: () async {
                  bool isAccessGranted = await ensureCameraPermission();
                  if (!isAccessGranted) {
                    return;
                  }
                  final photo =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  if (mounted) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SendImagePage(
                        image: File(photo!.path),
                        receiverId: item.owner.id,
                      ),
                    ));
                  }
                },
              ),
              PopupMenuItem(
                onTap: () async {
                  await _navigateToChatPage(item.owner.id);
                },
                child: Badge(
                  label: Text("!"),
                  isLabelVisible: messages.isNotEmpty,
                  child: Text("Chat pet's owner"),
                ),
              ),
            ];
          },
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PetDetailsPage(
              petId: item.id,
              isOwner: false,
            ),
          ),
        );
      },
    );
  }
}
