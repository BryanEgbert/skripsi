import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/model/pet_daycare.dart';
import 'package:frontend/pages/details/pet_daycare_details_page.dart';
import 'package:frontend/provider/list_data_provider.dart';

class PaginatedPetDaycareGridView extends ConsumerStatefulWidget {
  final int pageSize;
  final double? longitude, latitude;

  const PaginatedPetDaycareGridView(this.longitude, this.latitude,
      {super.key, required this.pageSize});

  @override
  ConsumerState<PaginatedPetDaycareGridView> createState() =>
      _PaginatedPetDaycareGridViewState();
}

class _PaginatedPetDaycareGridViewState
    extends ConsumerState<PaginatedPetDaycareGridView> {
  final ScrollController _scrollController = ScrollController();
  List<PetDaycare> _records = [];

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
    if (!_hasMoreData) return; // Stop fetching if no more data

    setState(() => _isFetching = true);

    ref
        .read(
            petDaycaresProvider(widget.latitude, widget.longitude, _lastId, 10)
                .future)
        .then((newData) {
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
      log("err: $e");
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
      return ErrorText(
          errorText: _error.toString(),
          onRefresh: () async {
            _records = [];
            _fetchMoreData();
          });
    }

    return RefreshIndicator(
      onRefresh: () async {
        _records = [];
        _fetchMoreData();
      },
      child: (_isFetching && _records.isEmpty)
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.orange,
            ))
          : GridView.builder(
              itemCount: _records.length + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0.0,
                crossAxisSpacing: 0.0,
                mainAxisExtent: 250,
              ),
              itemBuilder: (context, index) {
                if (index < _records.length) {
                  return _buildCard(context, _records[index]);
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
            ),
    );
  }

  Widget _buildCard(BuildContext context, PetDaycare item) {
    return Card(
      elevation: 0,
      // color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PetDaycareDetailsPage(item.id),
          ));
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              thumbnail(item),
              SizedBox(height: 4),
              Text(
                item.name,
                style: TextStyle(fontSize: 12),
              ),
              Text(
                "${item.locality} (${(item.distance.toDouble() / 1000).toStringAsFixed(2)}km away)",
                style: TextStyle(fontSize: 10),
              ),
              SizedBox(height: 2),
              avgRatingWidget(item),
              SizedBox(height: 4),
              for (var price in item.prices) priceWidget(price),
            ],
          ),
        ),
      ),
    );
  }

  Widget thumbnail(PetDaycare item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Image.network(
        item.thumbnail
            .replaceFirst(RegExp(r'localhost:8080'), "http://10.0.2.2:8080"),
        height: 100,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              color: Colors.grey[400],
              height: 100,
              child: Center(
                child: Icon(Icons.hide_image),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget priceWidget(Price? price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          price!.petCategory.name,
          style: TextStyle(fontSize: 10),
        ),
        Text(
          "Rp. ${price.price}/${price.pricingType}",
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget avgRatingWidget(PetDaycare item) {
    return Row(
      children: [
        Icon(
          Icons.star,
          color: Colors.yellow[700],
          size: 16,
        ),
        Text(
          "${item.averageRating}/5 (${item.ratingCount})",
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
