import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/pet_category.dart';

class SelectPetTypeModal extends StatefulWidget {
  final void Function(int? value, int index)? onChanged;
  final int petCategoryId;
  final AsyncValue<List<PetCategory>> petCategory;

  const SelectPetTypeModal(this.petCategoryId, this.petCategory, this.onChanged,
      {super.key});

  @override
  State<SelectPetTypeModal> createState() => _SelectPetTypeModalState();
}

class _SelectPetTypeModalState extends State<SelectPetTypeModal> {
  int _petCategoryId = 0;

  @override
  void initState() {
    super.initState();
    _petCategoryId = widget.petCategoryId;
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.petCategory) {
      AsyncData(:final value) => ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            return RadioListTile(
              title: Text(value[index].name),
              subtitle: (value[index].sizeCategory.id != 0)
                  ? Text(
                      "${value[index].sizeCategory.minWeight.toInt()} kg - ${value[index].sizeCategory.maxWeight.toInt()} kg")
                  : null,
              value: value[index].id,
              groupValue: _petCategoryId,
              onChanged: (value) {
                if (widget.onChanged != null) {
                  widget.onChanged!(value, index);
                  setState(() {
                    _petCategoryId = value!;
                  });
                }
              },
            );
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
