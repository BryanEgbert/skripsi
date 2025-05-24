import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/model/booking_request.dart';
import 'package:frontend/pages/details/booking_request_details_page.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/slot_provider.dart';
import 'package:frontend/utils/formatter.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/show_confirmation_dialog.dart';

class ViewBookingRequestsPage extends ConsumerStatefulWidget {
  const ViewBookingRequestsPage({super.key});

  @override
  ConsumerState<ViewBookingRequestsPage> createState() =>
      _ViewBookingRequestsPageState();
}

class _ViewBookingRequestsPageState
    extends ConsumerState<ViewBookingRequestsPage> {
  final int _pageSize = 10;
  final ScrollController _scrollController = ScrollController();
  List<BookingRequest> _records = [];

  int _page = 1;
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

    ref
        .read(getBookingRequestsProvider(_page, _pageSize).future)
        .then((newData) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking Requests',
          style: TextStyle(color: Colors.orange),
        ),
        actions: appBarActions(),
      ),
      body: (_isFetching && _records.isEmpty)
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.orange,
            ))
          : (_error != null || _records.isEmpty)
              ? ErrorText(
                  errorText: _error != null
                      ? _error.toString()
                      : "No pet owners are booking your service",
                  onRefresh: () => _fetchMoreData(),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: Colors.grey,
                          ),
                          Text(
                            "Tap the cards to view booking details",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      Expanded(
                        child: _buildBookingRequestListView(),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildBookingRequestListView() {
    final slotState = ref.watch(slotStateProvider);
    log("slotState: $slotState");

    handleValue(slotState, context, ref.read(slotStateProvider.notifier).reset);

    return RefreshIndicator(
      onRefresh: () async {
        _records = [];
        _page = 1;
        _fetchMoreData();
      },
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: _records.length,
        itemBuilder: (context, index) {
          if (slotState.hasValue && !slotState.isLoading) {
            if (slotState.value == 204) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                setState(() {
                  _records.removeAt(index);
                });
                ref.read(slotStateProvider.notifier).reset();
              });
            }
          }
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    BookingRequestDetailsPage(_records[index]),
              ));
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _records[index].user.name,
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${formatDateStr(_records[index].startDate)} - ${formatDateStr(_records[index].endDate)}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white70,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    for (var val in _records[index].petCount)
                      Text(
                        "${val.total} ${val.petCategory.name}",
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white70,
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_records[index].pickupRequired)
                          Text(
                            "Pick-up required",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          )
                        else
                          Text(
                            "Pick-up not required",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        Row(
                          spacing: 8.0,
                          children: [
                            FilledButton(
                              onPressed: () {
                                ref
                                    .read(slotStateProvider.notifier)
                                    .acceptSlot(_records[index].id);
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 12),
                                minimumSize: Size(0, 0),
                              ),
                              child: Text(
                                "Accept",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            FilledButton(
                              onPressed: () {
                                showConfirmationDialog(
                                  context,
                                  "Reject Request",
                                  "Are you sure you want to reject this booking request? This action cannot be undone.",
                                  () => ref
                                      .read(slotStateProvider.notifier)
                                      .rejectSlot(_records[index].id),
                                );
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 12),
                                minimumSize: Size(0, 0),
                              ),
                              child: Text(
                                "Reject",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
