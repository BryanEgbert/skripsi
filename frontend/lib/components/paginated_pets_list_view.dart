import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/model/pet.dart';
import 'package:frontend/pages/details/pet_details_page.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/pet_provider.dart';

class PaginatedPetsListView extends ConsumerStatefulWidget {
  final int pageSize;
  const PaginatedPetsListView({super.key, required this.pageSize});

  @override
  ConsumerState<PaginatedPetsListView> createState() =>
      PaginatedPetsListViewState();
}

class PaginatedPetsListViewState extends ConsumerState<PaginatedPetsListView> {
  final ScrollController _scrollController = ScrollController();
  final List<Pet> _records = [];

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
      _error = e as String;
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
    return RefreshIndicator(
      onRefresh: () =>
          ref.refresh(petListProvider(_lastId, widget.pageSize).future),
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
                  errorText: _error!,
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
            onPressed: () {
              ref.read(petStateProvider.notifier).deletePet(item.id);
            },
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
            builder: (context) => PetDetailsPage(petId: item.id),
          ),
        );
      },
    );
  }
}
