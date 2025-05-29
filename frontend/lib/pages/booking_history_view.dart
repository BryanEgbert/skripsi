import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/components/modals/add_review_modal.dart';
import 'package:frontend/model/chat_message.dart';
import 'package:frontend/model/transaction.dart';
import 'package:frontend/pages/details/transaction_details_page.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/slot_provider.dart';
import 'package:frontend/utils/formatter.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/show_confirmation_dialog.dart';

class BookingHistoryView extends ConsumerStatefulWidget {
  final List<ChatMessage> messages;
  const BookingHistoryView(this.messages, {super.key});

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
        title: Text(
          'Booking History',
          style: TextStyle(color: Colors.orange),
        ),
        actions: petOwnerAppBarActions(widget.messages.length),
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
                      : "Your booking history shows here",
                  onRefresh: () async {
                    _records = [];
                    _page = 1;
                    _fetchMoreData();
                  })
              : _buildBookingHistoryList(),
    );
  }

  Widget _buildBookingHistoryList() {
    final slotState = ref.watch(slotStateProvider);

    handleError(slotState, context, ref.read(slotStateProvider.notifier).reset);

    return RefreshIndicator(
      onRefresh: () async {
        _records = [];
        _page = 1;
        _fetchMoreData();
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          spacing: 4,
          children: [
            Row(
              spacing: 4,
              children: [
                Icon(Icons.info_outline_rounded),
                Text(
                  "Tap the cards to view details",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey[700]
                        : Colors.white70,
                  ),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                itemCount: _records.length,
                itemBuilder: (context, index) {
                  Color statusColor = Colors.black;
                  Color chipColor = Colors.transparent;

                  if (slotState.hasValue && !slotState.isLoading) {
                    if (slotState.value == 204) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        setState(() {
                          ref.read(slotStateProvider.notifier).reset();
                        });
                      });
                    }
                  }

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

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            TransactionDetailsPage(_records[index].id),
                      ));
                    },
                    child: Card(
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
                                      "${formatDateStr(_records[index].startDate)} - ${formatDateStr(_records[index].endDate)}",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black
                                            : Colors.white70,
                                      ),
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
                            Text(
                              _records[index].petDaycare.address,
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white70,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                /// NOTE: status id:
                                /// - 1: waiting for confirmation
                                /// - 4: done
                                if (_records[index].status.id == 1)
                                  FilledButton(
                                    onPressed: () {
                                      showCancelBookingConfirmationDialog(
                                        context,
                                        "Are you sure you want to cancel this booking? This action cannot be undone.",
                                        () {
                                          ref
                                              .read(slotStateProvider.notifier)
                                              .cancelSlot(_records[index]
                                                  .bookedSlot
                                                  .id);

                                          setState(() {
                                            _records = [];
                                            _page = 1;
                                            _fetchMoreData();
                                          });
                                        },
                                      );
                                    },
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 12),
                                      minimumSize: Size(0, 0),
                                    ),
                                    child: Text(
                                      "Cancel Booking",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  )
                                else if (_records[index].status.id == 4)
                                  FilledButton(
                                    onPressed: () async {
                                      await showModalBottomSheet(
                                        context: context,
                                        builder: (context) => AddReviewModal(
                                            _records[index].petDaycare.id),
                                      );
                                    },
                                    style: FilledButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 12),
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
