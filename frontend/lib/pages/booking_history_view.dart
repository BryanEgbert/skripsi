import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/app_bar_back_button.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/model/transaction.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/utils/formatter.dart';

class BookingHistoryView extends ConsumerStatefulWidget {
  const BookingHistoryView({super.key});

  @override
  ConsumerState<BookingHistoryView> createState() => _BookingHistoryViewState();
}

class _BookingHistoryViewState extends ConsumerState<BookingHistoryView> {
  final int _pageSize = 10;
  final ScrollController _scrollController = ScrollController();
  List<Transaction> _records = [];

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

    ref.read(getTransactionsProvider(_page, _pageSize).future).then((newData) {
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
        backgroundColor: Color(0xFFFFF1E1),
        title: Text(
          'Booking History',
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
              : _buildBookingHistoryList(),
    );
  }

  Widget _buildBookingHistoryList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _records.length,
      padding: EdgeInsets.all(12),
      itemBuilder: (context, index) {
        Color statusColor = Colors.black;
        Color chipColor = Colors.transparent;

        if (_records[index].status.id == 1) {
          statusColor = Colors.deepOrange;
          chipColor = Color(0xFFFFF080);
        } else if (_records[index].status.id == 2 ||
            _records[index].status.id == 4) {
          statusColor = Colors.green;
          chipColor = Color(0xFFCAFFC7);
        } else if (_records[index].status.id == 3 ||
            _records[index].status.id == 5) {
          statusColor = Colors.red;
          chipColor = Color(0XFFFFD7D7);
        }

        return Card(
          child: Padding(
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
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
                          _records[index].petDaycare.name,
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "${formatDate(_records[index].startDate)} - ${formatDate(_records[index].endDate)}",
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: chipColor,
                      ),
                      child: Text(
                        _records[index].status.name,
                        style: TextStyle(
                          fontSize: 10,
                          color: statusColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Text(_records[index].petDaycare.address),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /// NOTE: status id:
                    /// - 1: waiting for confirmation
                    /// - 4: done
                    if (_records[index].status.id == 1)
                      // TODO: add cancel booking logic
                      FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          minimumSize: Size(0, 0),
                        ),
                        child: Text(
                          "Cancel Booking",
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    else if (_records[index].status.id == 4)
                      // TODO: add give review logic
                      FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          minimumSize: Size(0, 0),
                        ),
                        child: Text(
                          "Give Review",
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
