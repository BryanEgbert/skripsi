import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/model/pet.dart';
import 'package:frontend/pages/details/pet_details_page.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/list_data_provider.dart';

class ViewBookedPetsPage extends ConsumerStatefulWidget {
  const ViewBookedPetsPage({super.key});

  @override
  ConsumerState<ViewBookedPetsPage> createState() => _ViewBookedPetsPageState();
}

class _ViewBookedPetsPageState extends ConsumerState<ViewBookedPetsPage> {
  final ScrollController _scrollController = ScrollController();
  List<Pet> _records = [];
  final int _pageSize = 10;

  int _lastId = 0;
  bool _isFetching = false;
  bool _hasMoreData = true;
  String? _error;

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetching) {
      _fetchMoreData();
    }
  }

  void _fetchMoreData() {
    if (!_hasMoreData) return; // Stop fetching if no more data

    setState(() {
      _isFetching = true;
      _error = null;
    });

    ref.read(bookedPetsProvider(_lastId, _pageSize).future).then((newData) {
      if (newData.data.isNotEmpty) {
        setState(() {
          _records.addAll(newData.data);
          _lastId = newData.data.last.id;
        });
      } else {
        setState(() {
          _hasMoreData = false;
        });
      }
    }).catchError((e) {
      // _error = e as String;
      log("[INFO] error: $e");
    }).whenComplete(() => setState(() => _isFetching = false));
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchMoreData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("[INFO] booked pets: $_records");
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Booked Pets",
          style: TextStyle(color: Colors.orange),
        ),
        actions: appBarActions(ref.read(authProvider.notifier)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _records = [];
          _lastId = 0;
          _fetchMoreData();
        },
        child: (_isFetching && _records.isEmpty)
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.orange,
              ))
            : (_error == null)
                ? (_records.isEmpty)
                    ? ErrorText(
                        errorText: "There are no booked pets",
                        onRefresh: () => _fetchMoreData(),
                      )
                    : _buildListView()
                : ErrorText(
                    errorText: _error!,
                    onRefresh: () => _fetchMoreData(),
                  ),
      ),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      itemCount: _records.length + 1,
      itemBuilder: (context, index) {
        if (index < _records.length) {
          return _buildListTile(context, _records[index]);
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
            PopupMenuItem(
              child: Text("Log activity"),
              onTap: () {},
            ),
            PopupMenuItem(
              child: Text("Chat pet's owner"),
              onTap: () {},
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
