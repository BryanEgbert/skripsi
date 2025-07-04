import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/booking_request.dart';
import 'package:frontend/model/chat_message.dart';
import 'package:frontend/pages/details/booking_request_details_page.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/slot_provider.dart';
import 'package:frontend/utils/formatter.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/show_confirmation_dialog.dart';

class ViewBookingRequestsPage extends ConsumerStatefulWidget {
  final List<ChatMessage> messages;
  const ViewBookingRequestsPage(this.messages, {super.key});

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
          AppLocalizations.of(context)!.bookingQueue,
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
                      : AppLocalizations.of(context)!.noBookedPetOwners,
                  onRefresh: () => _refresh(),
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
                            AppLocalizations.of(context)!.tapCardsToViewDetails,
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

    handleValue(slotState, this, ref.read(slotStateProvider.notifier).reset);

    return RefreshIndicator.adaptive(
      onRefresh: () async {
        _refresh();
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
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Constants.primaryTextColor
                                    : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${formatDateStr(_records[index].startDate, context)} - ${formatDateStr(_records[index].endDate, context)}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white,
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
                            AppLocalizations.of(context)!.pickupRequired,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          )
                        else
                          Text(
                            AppLocalizations.of(context)!.pickupNotRequired,
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
                                AppLocalizations.of(context)!.accept,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            FilledButton(
                              onPressed: () {
                                showConfirmationDialog(
                                  context,
                                  AppLocalizations.of(context)!.rejectRequest,
                                  AppLocalizations.of(context)!
                                      .rejectRequestConfirmation,
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
                                AppLocalizations.of(context)!.reject,
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

  void _refresh() {
    setState(() {
      _records = [];
      _page = 1;
      _hasMoreData = true;
      _fetchMoreData();
    });
  }
}
