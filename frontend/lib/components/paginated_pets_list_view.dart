import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/model/pet.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/utils/handle_error.dart';

class PaginatedPetsListView extends ConsumerStatefulWidget {
  final int pageSize;
  final Widget Function(Pet pet) buildBody;
  const PaginatedPetsListView(
      {super.key, required this.pageSize, required this.buildBody});

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
      setState(() {
        _error = e;
      });
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
    if (_error != null) {
      handleValue(
          AsyncValue.error(_error.toString(), StackTrace.current), this);
    }

    // ref.listen(
    //   petStateProvider,
    //   (previous, next) {
    //     log("[PAGINATED PETS LIST VIEW] reload petListProvider, next: $next");
    //     if (next.hasError && !next.isLoading && !next.hasValue) {
    //       handleError(next, context);
    //     } else {
    //       if (next.value == 204) {
    //         setState(() {
    //           _records = [];
    //           _lastId = 0;
    //           _fetchMoreData();
    //         });
    //       }
    //     }
    //   },
    // );

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
                      return widget.buildBody(_records[index]);
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
}
