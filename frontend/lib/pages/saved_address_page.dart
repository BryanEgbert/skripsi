import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/saved_address.dart';
import 'package:frontend/pages/add_saved_address.dart';
import 'package:frontend/pages/edit/edit_saved_address_page.dart';
import 'package:frontend/provider/last_selected.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/saved_address_provider.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/show_confirmation_dialog.dart';

class SavedAddressPage extends ConsumerStatefulWidget {
  final int? selectedIndex;
  const SavedAddressPage({super.key, this.selectedIndex});

  @override
  ConsumerState<SavedAddressPage> createState() => _SavedAddressPageState();
}

class _SavedAddressPageState extends ConsumerState<SavedAddressPage> {
  final ScrollController _scrollController = ScrollController();
  List<SavedAddress> _records = [];

  int _page = 1;
  bool _isFetching = false;
  bool _hasMoreData = true;

  int _selectedIndex = -1;

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
    // _selectedIndex = widget.selectedIndex == null ? 0 : widget.selectedIndex!;
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
    final lastSelected = ref.watch(lastSelectedProvider);

    _selectedIndex = lastSelected.value ?? -1;

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

    handleError(savedAddressState, context);

    if (savedAddressState.hasValue) {
      if (savedAddressState.value! == 201 || savedAddressState.value! == 204) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          var snackbar = SnackBar(
            key: Key("success-message"),
            content: Text(
              AppLocalizations.of(context)!.operationSuccess,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.green[800],
          );

          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          ref.read(savedAddressStateProvider.notifier).reset();
        });

        setState(() {
          _records = [];
          _hasMoreData = true;
          _page = 1;
          _fetchMoreData();
        });
      }
    }

    return Scaffold(
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
        title: Text(
          AppLocalizations.of(context)!.savedAddress,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Constants.primaryTextColor
                : Colors.orange,
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.of(context).pop(_selectedIndex);
        //     },
        //     icon: Icon(
        //       Icons.save,
        //       color: Theme.of(context).brightness == Brightness.light
        //           ? Constants.primaryTextColor
        //           : Colors.orange,
        //     ),
        //   )
        // ],
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
                                // _selectedIndex = index;
                                ref
                                    .read(lastSelectedProvider.notifier)
                                    .set(index);
                              });
                            },
                            child: Card(
                              color: (index == _selectedIndex)
                                  ? Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.amber[200]
                                      : Colors.deepOrange[900]
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        if (index == _selectedIndex)
                                          Text(
                                            AppLocalizations.of(context)!
                                                .selected,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Constants.primaryTextColor
                                                  : Colors.orange,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                      ],
                                    ),
                                    Text(
                                      item.address,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      AppLocalizations.of(context)!.notes,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      item.notes ?? "-",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditSavedAddressPage(
                                                          item.id),
                                                ));
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? Constants.primaryTextColor
                                                    : Colors.orange,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showDeleteConfirmationDialog(
                                                context,
                                                AppLocalizations.of(context)!
                                                    .deleteAddressConfirmation,
                                                () {
                                              ref
                                                  .read(
                                                      savedAddressStateProvider
                                                          .notifier)
                                                  .deleteSavedAddress(item.id);
                                              if (index == lastSelected.value) {
                                                ref
                                                    .read(lastSelectedProvider
                                                        .notifier)
                                                    .set(-1);
                                                // setState(() {
                                                //   _selectedIndex =
                                                // });
                                              }
                                            });
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
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
