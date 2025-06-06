import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/components/modals/add_review_modal.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/chat_message.dart';
import 'package:frontend/model/transaction.dart';
import 'package:frontend/pages/details/transaction_details_page.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/review_provider.dart';
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

    ref.read(getBookedSlotsProvider(_page, _pageSize).future).then((newData) {
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

  void _refresh() {
    setState(() {
      _records = [];
      _page = 1;
      _hasMoreData = true;
      _fetchMoreData();
    });
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
      handleError(AsyncError(_error.toString(), StackTrace.current), context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.bookingHistory,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Constants.primaryTextColor
                : Colors.orange,
          ),
        ),
        actions: petOwnerAppBarActions(widget.messages.length),
      ),
      body: (_isFetching && _records.isEmpty)
          ? Center(child: CircularProgressIndicator.adaptive())
          : (_error != null || _records.isEmpty)
              ? ErrorText(
                  errorText: _error != null
                      ? _error.toString()
                      : AppLocalizations.of(context)!.bookingHistoryInfo,
                  onRefresh: () async {
                    _refresh();
                  })
              : _buildBookingHistoryList(),
    );
  }

  Widget _buildBookingHistoryList() {
    final slotState = ref.watch(slotStateProvider);
    final reviewState = ref.watch(reviewStateProvider);
    log("slotState: $slotState");

    if (_error != null) {
      handleError(AsyncError(_error!, StackTrace.current), context);
    }

    handleError(slotState, context);
    if (slotState.hasValue && !slotState.isLoading) {
      if (slotState.value == 204) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            _records = [];
            _page = 1;
            _hasMoreData = true;
            _fetchMoreData();
            ref.read(slotStateProvider.notifier).reset();
          });
        });
      }
    }

    if (reviewState.hasValue && !reviewState.isLoading) {
      if (reviewState.value == 201) {
        setState(() {
          _records = [];
          _page = 1;
          _fetchMoreData();
          ref.read(slotStateProvider.notifier).reset();
        });
      }
    }

    return RefreshIndicator.adaptive(
      onRefresh: () async {
        _refresh();
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
                  AppLocalizations.of(context)!.tapCardsToViewDetails,
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
                    statusColor = Colors.green[900]!;
                    chipColor = Color(0xFFCAFFC7);
                  } else if (_records[index].status.id == 3 ||
                      _records[index].status.id == 5) {
                    statusColor = Colors.red[900]!;
                    chipColor = Color(0XFFFFD7D7);
                  }

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            BookingHistoryDetailsPage(_records[index].id),
                      ));
                    },
                    child: Card(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.orange[900]?.withAlpha(50)
                          : null,
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
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Constants.primaryTextColor
                                            : Colors.orange,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "${formatDateStr(_records[index].startDate, context)} - ${formatDateStr(_records[index].endDate, context)}",
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
                                        AppLocalizations.of(context)!
                                            .cancelBookingConfirmation,
                                        () {
                                          ref
                                              .read(slotStateProvider.notifier)
                                              .cancelSlot(_records[index]
                                                  .bookedSlot
                                                  .id);
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
                                      AppLocalizations.of(context)!
                                          .cancelBooking,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  )
                                else if (_records[index].status.id == 4 &&
                                    !_records[index].isReviewed)
                                  FilledButton(
                                    onPressed: () async {
                                      await showModalBottomSheet(
                                        context: context,
                                        builder: (context) => AddReviewModal(
                                          _records[index].petDaycare,
                                        ),
                                      );

                                      _refresh();
                                    },
                                    style: FilledButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 12),
                                      minimumSize: Size(0, 0),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.giveReview,
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
