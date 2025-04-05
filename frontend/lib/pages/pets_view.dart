import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/paginated_pets_list_view.dart';
import 'package:frontend/provider/auth_provider.dart';

class PetsView extends ConsumerStatefulWidget {
  const PetsView({super.key});

  @override
  ConsumerState<PetsView> createState() => _PetsViewState();
}

class _PetsViewState extends ConsumerState<PetsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pets",
          style: TextStyle(color: Colors.orange),
        ),
        actions: appBarActions(ref.read(authProvider.notifier)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.orange,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: PaginatedPetsListView(pageSize: 10),
    );
  }
}
