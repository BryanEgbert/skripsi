import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/vaccine_record.dart';
import 'package:frontend/pages/edit/edit_vaccination_record_page.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/vaccination_record_provider.dart';
import 'package:frontend/utils/formatter.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/show_confirmation_dialog.dart';

class PaginatedVaccineRecordsListView extends ConsumerStatefulWidget {
  final int petId;
  final int pageSize;
  final bool isOwner;

  const PaginatedVaccineRecordsListView(
    this.petId, {
    super.key,
    required this.pageSize,
    required this.isOwner,
  });

  @override
  ConsumerState<PaginatedVaccineRecordsListView> createState() =>
      _PaginatedListViewState();
}

class _PaginatedListViewState
    extends ConsumerState<PaginatedVaccineRecordsListView> {
  final ScrollController _scrollController = ScrollController();
  List<VaccineRecord> _records = [];

  int _page = 1;
  bool _isFetching = false;
  bool _hasMoreData = true;

  int _deleteIndex = -1;

  Object? _error;

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isFetching) {
      _fetchMoreData();
    }
  }

  void _fetchMoreData() {
    if (!_hasMoreData) return; // Stop fetching if no more data

    setState(() => _isFetching = true);

    ref
        .read(
            vaccineRecordsProvider(widget.petId, _page, widget.pageSize).future)
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
    final vaccinationRecord = ref.watch(vaccinationRecordStateProvider);

    if (_error != null) {
      handleError(
          AsyncValue.error(_error.toString(), StackTrace.current), context);
    }

    handleError(vaccinationRecord, context);

    if (vaccinationRecord.hasValue && !vaccinationRecord.isLoading) {
      if (vaccinationRecord.value != null) {
        if (vaccinationRecord.value! >= 200 &&
            vaccinationRecord.value! <= 400) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            var snackbar = SnackBar(
              key: Key("success-message"),
              content: Text(
                AppLocalizations.of(context)!.operationSuccess,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.green[800],
            );

            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            if (_deleteIndex != -1) {
              setState(() {
                _records.removeAt(_deleteIndex);
                _deleteIndex = -1;
              });
            }
            ref.read(vaccinationRecordStateProvider.notifier).reset();
            _records = [];
            _page = 1;
            _fetchMoreData();
          });
        }
      }
    }

    return RefreshIndicator.adaptive(
      onRefresh: () async {
        _records = [];
        _page = 1;
        _fetchMoreData();
      },
      child: (_isFetching)
          ? Center(child: CircularProgressIndicator.adaptive())
          : (_records.isNotEmpty)
              ? ListView.builder(
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
                )
              : Center(
                  child: Text(
                    AppLocalizations.of(context)!.noVaccinationRecord,
                    textAlign: TextAlign.center,
                  ),
                ),
    );
  }

  Widget _buildVaccineCard(VaccineRecord vaccineRecord, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Card(
        color: Theme.of(context).brightness == Brightness.light
            ? Color(0xFFFDF6EC)
            : null,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${AppLocalizations.of(context)!.dateAdministered}:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Constants.primaryTextColor
                            : Colors.orange,
                      ),
                    ),
                    Text(
                      formatDateStr(vaccineRecord.dateAdministered, context),
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    Text(
                      "${AppLocalizations.of(context)!.nextDueDate}:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Constants.primaryTextColor
                            : Colors.orange,
                      ),
                    ),
                    Text(
                      formatDateStr(vaccineRecord.nextDueDate, context),
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showGeneralDialog(
                        context: context,
                        barrierColor: Colors.black.withValues(alpha: 0.5),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return SizedBox.expand(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: InteractiveViewer(
                                child: Image.network(
                                  vaccineRecord.imageUrl,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.withAlpha(125),
                                      child: Column(
                                        spacing: 8,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image_not_supported,
                                            size: 32,
                                            semanticLabel:
                                                AppLocalizations.of(context)!
                                                    .failToLoadImage,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .failToLoadImage,
                                            style: TextStyle(
                                              fontSize: 12,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.image,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.primaryTextColor
                          : Colors.orange,
                    ),
                  ),
                  if (widget.isOwner)
                    PopupMenuButton(
                      iconColor:
                          Theme.of(context).brightness == Brightness.light
                              ? Constants.primaryTextColor
                              : Colors.orange,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: "edit",
                          child: Row(
                            spacing: 8,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit),
                              Text(AppLocalizations.of(context)!.edit),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditVaccinationRecordPage(
                                  vaccineRecord.id, widget.petId),
                            ));
                          },
                        ),
                        PopupMenuItem(
                          value: "delete",
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 8,
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              Text(
                                AppLocalizations.of(context)!.delete,
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          onTap: () {
                            showDeleteConfirmationDialog(
                                context,
                                AppLocalizations.of(context)!
                                    .confirmDeleteVaccination, () {
                              ref
                                  .read(vaccinationRecordStateProvider.notifier)
                                  .delete(vaccineRecord.id, widget.petId,
                                      widget.pageSize);
                            });

                            _deleteIndex = index;
                            // setState(() {
                            //   _records.removeAt(index);
                            // });
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
