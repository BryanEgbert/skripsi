import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/pet.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/pages/chat_page.dart';
import 'package:frontend/pages/details/pet_details_page.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/list_data_provider.dart';

class ViewBookedPetsPage extends ConsumerStatefulWidget {
  const ViewBookedPetsPage({super.key});

  @override
  ConsumerState<ViewBookedPetsPage> createState() => _ViewBookedPetsPageState();
}

class _ViewBookedPetsPageState extends ConsumerState<ViewBookedPetsPage> {
  final ScrollController _scrollPetController = ScrollController();
  final ScrollController _scrollPetOwnerController = ScrollController();

  List<Pet> _petRecords = [];
  List<User> _bookedPetRecords = [];
  final int _pageSize = 10;

  int _lastId = 0;
  int _page = 1;
  bool _isFetching = false;
  bool _hasMoreData = true;
  String? _error;

  void _navigateToChatPage(int userId) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ChatPage(userId: userId)));
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

  @override
  void initState() {
    super.initState();

    _scrollPetController.addListener(_onScroll);
    _scrollPetOwnerController.addListener(_onPetOwnerScroll);

    _fetchMoreData(0);
    _fetchMoreData(1);
  }

  @override
  void dispose() {
    _scrollPetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("[INFO] booked pets: $_petRecords");
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Booked Pets",
            style: TextStyle(color: Colors.orange),
          ),
          actions: appBarActions(ref.read(authProvider.notifier)),
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
          _buildViewByPets(),
          _buildViewByPetOwners(),
        ]),
      ),
    );
  }

  Widget _buildViewByPetOwners() {
    return RefreshIndicator(
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
                  : _buildBookedPetOwnersListView()
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

  Widget _buildViewByPets() {
    return RefreshIndicator(
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
                  : _buildPetsListView()
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

  Widget _buildBookedPetOwnersListView() {
    return ListView.builder(
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
            trailing: IconButton(
              onPressed: () {
                _navigateToChatPage(_bookedPetRecords[index].id);
              },
              icon: Icon(
                Icons.chat_rounded,
                color: Constants.primaryTextColor,
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
    );
  }

  Widget _buildPetsListView() {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      controller: _scrollPetController,
      itemCount: _petRecords.length + 1,
      itemBuilder: (context, index) {
        if (index < _petRecords.length) {
          return _buildListTile(context, _petRecords[index]);
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

  Widget _buildListTile(BuildContext context, Pet item) {
    return ListTile(
      leading: DefaultCircleAvatar(imageUrl: item.imageUrl ?? ""),
      title: Text(item.name),
      subtitle: Text(
          "Pet category: ${item.petCategory.name}\nStatus: ${item.status}\nOwner: ${item.owner.name}"),
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.orange,
      ),
      subtitleTextStyle: TextStyle(fontSize: 14, color: Colors.black),
      trailing: PopupMenuButton(
        itemBuilder: (context) {
          return [
            // TODO: add log pet functionality
            PopupMenuItem(
              child: Text("Log activity"),
              onTap: () {},
            ),
            PopupMenuItem(
              onTap: () {
                _navigateToChatPage(item.owner.id);
              },
              child: Text("Chat pet's owner"),
            ),
          ];
        },
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
