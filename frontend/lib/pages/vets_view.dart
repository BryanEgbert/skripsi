import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/utils/handle_error.dart';

class VetsView extends ConsumerStatefulWidget {
  const VetsView({super.key});

  @override
  ConsumerState<VetsView> createState() => _VetsViewState();
}

class _VetsViewState extends ConsumerState<VetsView> {
  // TODO: Complete view vet page
  final ScrollController _scrollController = ScrollController();
  List<User> _records = [];

  int _lastId = 0;
  bool _isFetching = false;
  bool _hasMoreData = true;

  Object? _error;

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
      handleError(
        AsyncValue.error(_error.toString(), StackTrace.current),
        context,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: Icon(
              Icons.search_rounded,
            ),
            labelStyle: TextStyle(fontSize: 12),
            isDense: true,
            labelText: "Search vets",
          ),
        ),
        actions: appBarActions(ref.read(authProvider.notifier)),
      ),
      body: RefreshIndicator(
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
              tileColor: Color(0xFFFFF1E1),
              // TODO: navigate to chat page
              onTap: () {},
              leading: DefaultCircleAvatar(
                imageUrl: _records[index].imageUrl,
                iconSize: 56,
              ),
              title: Text(
                _records[index].name,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              subtitle: Text("Specialties: ${vetSpecialtyNames.join(", ")}"),
            );
          },
        ),
      ),
    );
  }
}
