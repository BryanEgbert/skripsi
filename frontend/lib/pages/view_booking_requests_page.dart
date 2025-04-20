import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/model/booking_request.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/utils/formatter.dart';

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
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
        actions: appBarActions(ref.read(authProvider.notifier)),
      ),
      body: (_isFetching && _records.isEmpty)
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.orange,
            ))
          : (_error != null)
              ? ErrorText(
                  errorText: _error!.toString(),
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
    return RefreshIndicator(
      onRefresh: () async {
        _records = [];
        _page = 1;
        _fetchMoreData();
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _records.length,
        itemBuilder: (context, index) {
          return InkWell(
            // TODO: Navigate to booking details
            onTap: () {},
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
                              "${formatDate(_records[index].startDate)} - ${formatDate(_records[index].endDate)}",
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    for (var val in _records[index].petCount)
                      Text("${val.total} ${val.petCategory.name}"),
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
                            // TODO: add accept and reject logic
                            FilledButton(
                              onPressed: () {},
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
                              onPressed: () {},
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
