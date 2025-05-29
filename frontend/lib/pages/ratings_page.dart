import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/app_bar_back_button.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/reviews.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/utils/formatter.dart';
import 'package:frontend/utils/handle_error.dart';

class RatingsPage extends ConsumerStatefulWidget {
  final int petDaycareId;
  final double ratingsAvg;
  final int ratingsCount;
  const RatingsPage(this.petDaycareId,
      {super.key, required this.ratingsAvg, required this.ratingsCount});

  @override
  ConsumerState<RatingsPage> createState() => _RatingsPageState();
}

class _RatingsPageState extends ConsumerState<RatingsPage> {
  final int _pageSize = 10;
  final ScrollController _scrollController = ScrollController();
  final List<Reviews> _records = [];

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
        .read(getReviewsProvider(widget.petDaycareId, _page, _pageSize).future)
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
    if (_error != null) {
      handleValue(
          AsyncValue.error(_error.toString(), StackTrace.current), this);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reviews',
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
        leading: appBarBackButton(context),
        actions: appBarActions(),
      ),
      body: (_isFetching && _records.isEmpty)
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.orange,
            ))
          : (_error == null)
              ? Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.secondaryBackgroundColor
                          : null,
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 40),
                          SizedBox(width: 8),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.ratingsAvg.toString(),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white70,
                                  ),
                                ),
                                TextSpan(
                                  text: '/5',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Text(
                            '${widget.ratingsCount} Reviews',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(top: 8),
                        itemCount: _records.length,
                        itemBuilder: (context, index) =>
                            _buildReviewCard(_records[index]),
                      ),
                    ),
                  ],
                )
              : ErrorText(
                  errorText: _error!.toString(),
                  onRefresh: () => _fetchMoreData(),
                ),
    );
  }

  Widget _buildReviewCard(Reviews value) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      color: Theme.of(context).brightness == Brightness.light
          ? Constants.secondaryBackgroundColor
          : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  foregroundImage: NetworkImage(value.user.imageUrl),
                  radius: 20,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value.user.name,
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      spacing: 6,
                      children: [
                        StarRating(
                          rating: value.rating.toDouble(),
                          allowHalfRating: false,
                        ),
                        Text(formatDateStr(value.createdAt),
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value.description,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
