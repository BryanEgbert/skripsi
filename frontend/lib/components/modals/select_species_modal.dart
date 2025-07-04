import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/category_provider.dart';

class SelectSpeciesModal extends ConsumerStatefulWidget {
  const SelectSpeciesModal({super.key});

  @override
  ConsumerState<SelectSpeciesModal> createState() => _SelectSpeciesPageState();
}

class _SelectSpeciesPageState extends ConsumerState<SelectSpeciesModal> {
  int speciesId = 0;
  int currentValue = 1;

  @override
  Widget build(BuildContext context) {
    final petCategory = ref.watch(petCategoryProvider);
    log("petCategory: ${petCategory.toString()}");

    return switch (petCategory) {
      AsyncData(:final value) =>
        ListView.builder(itemBuilder: (context, index) {
          return RadioListTile(
              title: Text(value[index].name),
              value: value[index].id,
              groupValue: currentValue,
              onChanged: (int? v) {
                speciesId = v!;
                setState(() {
                  currentValue = v;
                });
              });
        }),
      AsyncError() => SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Center(child: const Text("Something's wrong")),
        ),
      _ => SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: const CircularProgressIndicator(),
          ),
        ),
    };
  }
}
