import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/error_text.dart';
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
          title: Text("Pets"),
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
                    leading: CircleAvatar(
                      child: Image.network(
                        imageUrl.replaceFirst(
                            RegExp(r'localhost:8080'), "http://10.0.2.2:8080"),
                        errorBuilder: (context, error, stackTrace) {
                          return CircleAvatar(
                            child: Center(
                              child: Icon(Icons.hide_image),
                            ),
                          );
                        },
                      ),
                    ),
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
                          // TODO: delete pet
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
                    onTap: () {},
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
