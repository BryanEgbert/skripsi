import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/reduced_slot.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/pet_daycare_provider.dart';
import 'package:frontend/utils/formatter.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/show_confirmation_dialog.dart';

class ViewSlotsPage extends ConsumerStatefulWidget {
  const ViewSlotsPage({super.key});

  @override
  ConsumerState<ViewSlotsPage> createState() => _ViewSlotsPageState();
}

class _ViewSlotsPageState extends ConsumerState<ViewSlotsPage> {
  final int _pageSize = 10;
  final ScrollController _scrollController = ScrollController();
  List<ReducedSlot> _records = [];

  int _page = 1;
  bool _isFetching = false;
  bool _hasMoreData = true;
  Object? _error;

  void _refresh() {
    setState(() {
      _records = [];
      _page = 1;
      _hasMoreData = true;
      _fetchMoreData();
    });
  }

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

    ref.read(reducedSlotsProvider(_page, _pageSize).future).then((newData) {
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
    final petDaycareState = ref.watch(petDaycareStateProvider);

    handleValue(petDaycareState, this);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reduced Slots',
          style: TextStyle(color: Colors.orange),
        ),
        actions: appBarActions(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        // TODO: edit reduce slot
        onPressed: () {},
        label: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.orange,
      ),
      body: (_isFetching && _records.isEmpty)
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.orange,
            ))
          : (_error == null)
              ? (_records.isEmpty)
                  ? ErrorText(
                      errorText: "The list is empty",
                      onRefresh: () => _refresh(),
                    )
                  : _buildListView()
              : ErrorText(
                  errorText: _error.toString(),
                  onRefresh: () => _refresh(),
                ),
    );
  }

  Widget _buildListView() {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        _refresh();
      },
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: _records.length,
        itemBuilder: (context, index) {
          return Card(
            // color: Constants.secondaryBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatDateStr(_records[index].targetDate, context),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Constants.primaryTextColor,
                        ),
                      ),
                      Text(
                        "Reduced Slots: ${_records[index].reducedCount}",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // TODO: edit reduced count
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.edit,
                          color: Colors.orange,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDeleteConfirmationDialog(context,
                              "Are you sure? this action cannot be undone.",
                              () {
                            ref
                                .read(petDaycareStateProvider.notifier)
                                .deleteReduceSlot(_records[index].id);

                            setState(() {
                              ref.invalidate(petDaycareStateProvider);
                              _refresh();
                            });
                          });
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
