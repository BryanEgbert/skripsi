import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/model/pet.dart';
import 'package:frontend/pages/details/pet_details_page.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/pet_provider.dart';
import 'package:frontend/utils/handle_error.dart';

class PaginatedPetsListView extends ConsumerStatefulWidget {
  final int pageSize;
  const PaginatedPetsListView({super.key, required this.pageSize});

  @override
  ConsumerState<PaginatedPetsListView> createState() =>
      PaginatedPetsListViewState();
}

class PaginatedPetsListViewState extends ConsumerState<PaginatedPetsListView> {
  final ScrollController _scrollController = ScrollController();
  List<Pet> _records = [];

  int _lastId = 0;
  bool _isFetching = false;
  bool _hasMoreData = true;
  Object? _error;

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetching) {
      _fetchMoreData();
    }
  }

  void _fetchMoreData() {
    if (!_hasMoreData) return;

    setState(() {
      _isFetching = true;
      _error = null;
    });

    ref.read(petListProvider(_lastId, widget.pageSize).future).then((newData) {
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
      _error = e;
    }).whenComplete(() => setState(() => _isFetching = false));
  }

  void _deletePet(int petId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
              "Are you sure you want to delete this pet? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                ref.read(petStateProvider.notifier).deletePet(petId);
                Navigator.of(context).pop();
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
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
    if (_error != null) {
      handleError(
          AsyncValue.error(_error.toString(), StackTrace.current), context);
    }

    return RefreshIndicator(
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
              ? ListView.builder(
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
                )
              : ErrorText(
                  errorText: _error!.toString(),
                  onRefresh: () => _fetchMoreData(),
                ),
    );
  }

  Widget _buildListTile(BuildContext context, Pet item) {
    return ListTile(
      leading: DefaultCircleAvatar(imageUrl: item.imageUrl ?? ""),
      title: Text(item.name),
      subtitle: Text(
          "Pet category: ${item.petCategory.name}\nStatus: ${item.status}"),
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.orange,
      ),
      subtitleTextStyle: TextStyle(fontSize: 14, color: Colors.black),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // TODO: edit pet
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.edit,
              color: Colors.orange[600],
            ),
          ),
          IconButton(
            onPressed: () => _deletePet(item.id),
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PetDetailsPage(
              petId: item.id,
              isOwner: true,
            ),
          ),
        );
      },
    );
  }
}
