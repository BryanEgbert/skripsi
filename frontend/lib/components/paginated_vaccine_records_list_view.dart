import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/vaccine_record.dart';
import 'package:frontend/pages/edit/edit_vaccination_record_page.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/vaccination_record_provider.dart';
import 'package:frontend/utils/formatter.dart';
import 'package:frontend/utils/handle_error.dart';

class PaginatedVaccineRecordsListView extends ConsumerStatefulWidget {
  final int petId;
  final int pageSize;
  const PaginatedVaccineRecordsListView(this.petId,
      {super.key, required this.pageSize});

  @override
  ConsumerState<PaginatedVaccineRecordsListView> createState() =>
      _PaginatedListViewState();
}

class _PaginatedListViewState
    extends ConsumerState<PaginatedVaccineRecordsListView> {
  final ScrollController _scrollController = ScrollController();
  final List<VaccineRecord> _records = [];

  int _lastId = 0;
  bool _isFetching = false;
  bool _hasMoreData = true;

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
        .read(vaccineRecordsProvider(widget.petId, _lastId, widget.pageSize)
            .future)
        .then((newData) {
          if (newData.data.isNotEmpty) {
            setState(() {
              _records.addAll(newData.data);
              _lastId = newData.data.last!.id;
            });
          } else {
            setState(() {
              _hasMoreData = false;
            });
          }
        })
        .catchError((e) {})
        .whenComplete(() => setState(() => _isFetching = false));
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
    final vaccinationRecord = ref.watch(vaccinationRecordStateProvider);

    handleError(vaccinationRecord, context);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(
          vaccineRecordsProvider(widget.petId, _lastId, widget.pageSize)
              .future),
      child: (_isFetching && _records.isEmpty)
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.orange,
            ))
          : ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              itemCount: _records.length + 1,
              itemBuilder: (context, index) {
                if (index < _records.length) {
                  return _buildVaccineCard(_records[index], index);
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

  Widget _buildVaccineCard(VaccineRecord vaccineRecord, int index) {
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
                  PopupMenuButton(
                    iconColor: Colors.orange,
                    itemBuilder: (context) => [
                      // TODO: edit function
                      PopupMenuItem(
                        value: "edit",
                        child: Text("Edit"),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditVaccinationRecordPage(
                                vaccineRecord.id, widget.petId),
                          ));
                        },
                      ),
                      PopupMenuItem(
                        value: "delete",
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          ref
                              .read(vaccinationRecordStateProvider.notifier)
                              .delete(vaccineRecord.id);
                          setState(() {
                            _records.removeAt(index);
                          });
                        },
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
