import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/model/pagination_query_params.dart';
import 'package:frontend/model/pet.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/model/vaccine_record.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/utils/formatter.dart';

class PetDetailsPage extends ConsumerStatefulWidget {
  final int petId;
  const PetDetailsPage({super.key, required this.petId});

  @override
  ConsumerState<PetDetailsPage> createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends ConsumerState<PetDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  int _lastId = 0;
  final _pageSize = 10;
  bool _isFetching = false;
  bool _hasMoreData = true;
  List<VaccineRecord?> _records = [];

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

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetching) {
      _fetchMoreData();
    }
  }

  void _fetchMoreData() {
    log("[INFO] isFetching: $_isFetching");
    if (!_hasMoreData) return; // Stop fetching if no more data

    setState(() => _isFetching = true);

    ref
        .read(vaccineRecordsProvider(widget.petId, _lastId, _pageSize).future)
        .then((newData) {
      log("newData: ${newData.data}");

      if (newData.data.isNotEmpty) {
        setState(() {
          _records.addAll(newData.data);
          _lastId = newData.data.last!.id; // Update lastId for pagination
        });
      } else {
        setState(() {
          _hasMoreData = false; // No more data to fetch
        });
      }
    }).catchError((e) {
      log("Error fetching more data: $e");
    }).whenComplete(() => setState(() => _isFetching = false));
  }

  @override
  Widget build(BuildContext context) {
    final pet = ref.watch(petProvider(widget.petId));

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: switch (pet) {
          AsyncError(:final error) => ErrorText(
              errorText: error.toString(),
              onRefresh: () => ref.refresh(petProvider(widget.petId).future),
            ),
          AsyncData(:final value) => _buildBody(value),
          _ => CircularProgressIndicator(
              color: Colors.orange,
            ),
        });
  }

  Widget _buildBody(Pet petValue) {
    final vaccineRecord =
        ref.watch(vaccineRecordsProvider(widget.petId, _lastId, _pageSize));

    return vaccineRecord.when(
      data: (value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPetDetails(petValue),
            SizedBox(height: 8),
            Container(
              color: Color(0xFFFFF1E1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Vaccination Records",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add,
                        color: Colors.orange,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Color(0xFFFFF1E1),
                child: _buildVaccineRecordsListView(value.data),
              ),
            ),
          ],
        );
      },
      error: (error, _) => ErrorText(
          errorText: error.toString(),
          onRefresh: () => ref.refresh(
              vaccineRecordsProvider(widget.petId, _lastId, _pageSize).future)),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildPetDetails(Pet petValue) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Color(0xFFFFF1E1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              DefaultCircleAvatar(
                imageUrl: petValue.imageUrl ?? "",
                iconSize: 30,
                circleAvatarRadius: 30,
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    petValue.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  Text("pet category: ${petValue.petCategory.name}"),
                  Text("status: ${petValue.status}"),
                  // Text("owner: pet owner's name"),
                ],
              ),
            ],
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.edit,
                color: Colors.orange,
              ))
        ],
      ),
    );
  }

  Widget _buildVaccineRecordsListView(List<VaccineRecord?> records) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _records.length + 1,
      itemBuilder: (context, index) {
        if (index < _records.length) {
          return _buildVaccineCard(_records[index]!);
        } else {
          if (_isFetching) {
            return Center(child: CircularProgressIndicator());
          } else if (!_hasMoreData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "No more vaccine records available",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          } else {
            return SizedBox();
          }
        }
      },
    );
  }

  Widget _buildVaccineCard(VaccineRecord vaccineRecord) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Card(
        color: Color(0xFFFDF6EC),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Date Administered:",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  Text(formatDate(vaccineRecord.dateAdministered)),
                  Text(
                    "Next Due Date:",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  Text(formatDate(vaccineRecord.nextDueDate)),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showGeneralDialog(
                        context: context,
                        barrierColor: Colors.black.withValues(alpha: 0.5),
                        barrierLabel: 'Image details',
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return SizedBox.expand(
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Image.network(vaccineRecord.imageUrl)),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.image, color: Colors.orange),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.more_vert, color: Colors.orange),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
