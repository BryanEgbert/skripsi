import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/size_category.dart';
import 'package:frontend/provider/category_provider.dart';
import 'package:frontend/repository/category_service.dart';

class SelectPetSizeModal extends ConsumerStatefulWidget {
  const SelectPetSizeModal({super.key});

  @override
  ConsumerState<SelectPetSizeModal> createState() => _SelectPetSizeModalState();
}

class _SelectPetSizeModalState extends ConsumerState<SelectPetSizeModal> {
  int speciesId = 0;
  int currentValue = 1;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<SizeCategory>> species =
        ref.read(sizeCategoriesProvider(CategoryService()));

    return switch (species) {
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
