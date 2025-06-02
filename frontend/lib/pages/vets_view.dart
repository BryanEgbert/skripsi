import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/chat_message.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/pages/chat_page.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/utils/handle_error.dart';

class VetsView extends ConsumerStatefulWidget {
  final List<ChatMessage> messages;
  const VetsView(this.messages, {super.key});

  @override
  ConsumerState<VetsView> createState() => _VetsViewState();
}

class _VetsViewState extends ConsumerState<VetsView> {
  final ScrollController _scrollController = ScrollController();
  List<User> _records = [];

  int _lastId = 0;
  bool _isFetching = false;
  bool _hasMoreData = true;

  Object? _error;

  final List<Map<String, dynamic>> vetSpecialties = [
    {'id': 1, 'name': 'General Practice'},
    {'id': 2, 'name': 'Preventive Medicine'},
    {'id': 3, 'name': 'Emergency & Critical Care'},
    {'id': 4, 'name': 'Internal Medicine'},
    {'id': 5, 'name': 'Cardiology'},
    {'id': 6, 'name': 'Neurology'},
    {'id': 7, 'name': 'Oncology'},
    {'id': 8, 'name': 'Gastroenterology'},
    {'id': 9, 'name': 'Dermatology & Allergy Care'},
    {'id': 10, 'name': 'Dentistry & Oral Surgery'},
    {'id': 11, 'name': 'Behavioral Medicine'},
    {'id': 12, 'name': 'Surgery & Orthopedics'},
    {'id': 13, 'name': 'Soft Tissue Surgery'},
    {'id': 14, 'name': 'Orthopedic Surgery'},
    {'id': 15, 'name': 'Ophthalmology'},
    {'id': 16, 'name': 'Rehabilitation & Physical Therapy'},
    {'id': 17, 'name': 'Exotic & Small Animal Care'},
  ];

  // ignore: prefer_final_fields
  int _vetSpecialtyId = 0;

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetching) {
      _fetchMoreData();
    }
  }

  void _fetchMoreData() {
    if (!_hasMoreData) return; // Stop fetching if no more data

    setState(() {
      _isFetching = true;
      _error = null;
    });

    ref
        .read(getVetsProvider(_lastId, 10, _vetSpecialtyId).future)
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
      _error = e;
      log("error: $e");
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
      handleError(AsyncError(_error!, StackTrace.current), context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Vets",
          style: TextStyle(color: Colors.orange),
        ),
        actions: [
          Builder(builder: (context) {
            return IconButton(
              icon: Icon(Icons.tune_rounded),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          }),
          ...petOwnerAppBarActions(widget.messages.length),
        ],
      ),
      endDrawer: Container(
        padding: EdgeInsets.all(8),
        color: Theme.of(context).brightness == Brightness.light
            ? Constants.secondaryBackgroundColor
            : Constants.darkBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.navigate_before,
                              color: Constants.primaryTextColor,
                            ),
                          ),
                          Text(
                            "Back",
                            style: TextStyle(
                              color: Constants.primaryTextColor,
                            ),
                          )
                        ],
                      ),
                      Text(
                        "Vet Specialties",
                        style: TextStyle(
                          color: Constants.primaryTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children: vetSpecialties.map((specialty) {
                          final int id = specialty['id'];
                          final String name = specialty['name'];
                          return FilterChip(
                            label: Text(name),
                            selected: _vetSpecialtyId == id,
                            onSelected: (bool selected) {
                              setState(() {
                                _vetSpecialtyId = selected ? id : 0;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _records = [];
                  _lastId = 0;
                  _hasMoreData = true;
                  _fetchMoreData();
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  textStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              child: Text("Apply Filter"),
            ),
          ],
        ),
      ),
      body: (_error != null)
          ? ErrorText(
              errorText: _error.toString(),
              onRefresh: () async {
                _records = [];
                _lastId = 0;
                _hasMoreData = true;
                _fetchMoreData();
              })
          : RefreshIndicator.adaptive(
              onRefresh: () async {
                _records = [];
                _lastId = 0;
                _fetchMoreData();
              },
              child: ListView.builder(
                itemCount: _records.length,
                itemBuilder: (context, index) {
                  List<String> vetSpecialtyNames = [];
                  for (var val in _records[index].vetSpecialties) {
                    vetSpecialtyNames.add(val.name);
                  }
                  return ListTile(
                    tileColor: Theme.of(context).brightness == Brightness.light
                        ? Constants.secondaryBackgroundColor
                        : null,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatPage(userId: _records[index].id),
                        ),
                      );
                    },
                    leading: DefaultCircleAvatar(
                      imageUrl: _records[index].imageUrl,
                    ),
                    title: Text(
                      _records[index].name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    subtitle:
                        Text("Specialties: ${vetSpecialtyNames.join(", ")}"),
                  );
                },
              ),
            ),
    );
  }
}
