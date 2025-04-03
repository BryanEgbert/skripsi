import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/pages/details/pet_details_page.dart';
import 'package:frontend/provider/pet_list_provider.dart';

class PetsView extends ConsumerStatefulWidget {
  const PetsView({super.key});

  @override
  ConsumerState<PetsView> createState() => _PetsViewState();
}

class _PetsViewState extends ConsumerState<PetsView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getPets = ref.watch(petListProvider);
    log("getPets: $getPets");

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Pets",
            style: TextStyle(color: Colors.orange),
          ),
          actions: appBarActions(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.orange,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: switch (getPets) {
          // TODO: pagination on scroll down
          AsyncData(:final value) => RefreshIndicator(
              onRefresh: () => ref.refresh(petListProvider.future),
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                itemCount: value.data.length,
                itemBuilder: (context, index) {
                  var item = value.data[index];
                  var imageUrl = item.imageUrl ?? "";

                  return ListTile(
                    leading: DefaultCircleAvatar(imageUrl: imageUrl),
                    title: Text(item.name),
                    subtitle: Text(
                        "Pet category: ${item.petCategory.name}\nStatus: ${item.status}"),
                    titleTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                    subtitleTextStyle:
                        TextStyle(fontSize: 14, color: Colors.black),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // TODO: edit pet
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.edit,
                            color: Colors.orange[600],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ref.read(petListProvider.notifier).delete(item.id);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    // TODO: navigate to view pet details
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PetDetailsPage(petId: item.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          AsyncError(:final error) => ErrorText(
              errorText: error.toString(),
              onRefresh: () => ref.refresh(petListProvider.future),
            ),
          _ => Center(
              child: CircularProgressIndicator(),
            ),
        });
  }
}
