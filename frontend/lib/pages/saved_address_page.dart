import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/saved_address.dart';
import 'package:frontend/pages/add_saved_address.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/saved_address_provider.dart';

class SavedAddressPage extends ConsumerStatefulWidget {
  final int? selected;
  const SavedAddressPage({super.key, this.selected});

  @override
  ConsumerState<SavedAddressPage> createState() => _SavedAddressPageState();
}

class _SavedAddressPageState extends ConsumerState<SavedAddressPage> {
  final ScrollController _scrollController = ScrollController();
  List<SavedAddress> _records = [];

  int _page = 1;
  bool _isFetching = false;
  bool _hasMoreData = true;

  int _selectedIndex = 0;

  Object? _error;

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetching) {
      _fetchMoreData();
    }
  }

  void _fetchMoreData() {
    if (!_hasMoreData) return; // Stop fetching if no more data

    setState(() => _isFetching = true);

    ref.read(savedAddressProvider(_page, 100).future).then((newData) {
      if (newData.data.isNotEmpty) {
        setState(() {
          _records.addAll(newData.data);
          _page += 1;
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

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selected == null ? 0 : widget.selected!;
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
    final savedAddressState = ref.watch(savedAddressStateProvider);
    if (_error != null) {
      return ErrorText(
          errorText: _error.toString(),
          onRefresh: () async {
            _records = [];
            _hasMoreData = true;
            _page = 1;
            _fetchMoreData();
          });
    }

    if (savedAddressState.hasValue) {
      if (savedAddressState.value! == 201 || savedAddressState.value! == 204) {
        _records = [];
        _hasMoreData = true;
        _page = 1;
        _fetchMoreData();
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "Saved Address",
          style: TextStyle(color: Constants.primaryTextColor),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(_selectedIndex);
            },
            icon: Icon(
              Icons.save,
              color: Colors.orange,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddSavedAddress(),
          ));
        },
        label: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: (_isFetching && _records.isEmpty)
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.orange,
            ))
          : (_error == null)
              ? RefreshIndicator.adaptive(
                  onRefresh: () async {
                    _records = [];
                    _hasMoreData = true;
                    _page = 1;
                    _fetchMoreData();
                  },
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    itemCount: _records.length + 1,
                    itemBuilder: (context, index) {
                      if (index < _records.length) {
                        var item = _records[index];
                        return Container(
                          margin: EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            child: Card(
                              color: (index == _selectedIndex)
                                  ? Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Constants.secondaryBackgroundColor
                                      : Colors.deepOrange[900]
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      item.address,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Notes",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      item.notes ?? "-",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    if (index == _selectedIndex)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Selected",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Constants.primaryTextColor
                                                  : Colors.orange[50],
                                            ),
                                          )
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        if (_isFetching) {
                          return Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }

                        return SizedBox();
                      }
                    },
                  ),
                )
              : ErrorText(
                  errorText: _error!.toString(),
                  onRefresh: () => _fetchMoreData(),
                ),
    );
  }
}
