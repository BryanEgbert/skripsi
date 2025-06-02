import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/provider/category_provider.dart';

class SelectPetTypeModal extends ConsumerStatefulWidget {
  const SelectPetTypeModal({super.key});

  @override
  ConsumerState<SelectPetTypeModal> createState() => _SelectPetTypeModalState();
}

class _SelectPetTypeModalState extends ConsumerState<SelectPetTypeModal> {
  @override
  Widget build(BuildContext context) {
    final petCategory = ref.watch(petCategoryProvider);

    return switch (petCategory) {
      AsyncData(:final value) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Choose pet category",
                style: TextStyle(color: Colors.orange[600]),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(value[index].name),
                        subtitle: (value[index].sizeCategory.id != 0)
                            ? (value[index].sizeCategory.maxWeight != null)
                                ? Text(
                                    "${value[index].sizeCategory.minWeight.toInt()} kg - ${value[index].sizeCategory.maxWeight!.toInt()} kg")
                                : Text(
                                    "${value[index].sizeCategory.minWeight.toInt()} kg+")
                            : null,
                        onTap: () {
                          Navigator.of(context).pop(
                            Lookup(
                              id: value[index].id,
                              name: value[index].name,
                            ),
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      AsyncError() => SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Something's wrong"),
              IconButton(
                onPressed: () => ref.refresh(petCategoryProvider.future),
                icon: Icon(
                  Icons.refresh,
                  color: Colors.orange,
                ),
              )
            ],
          ),
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
