import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/provider/category_provider.dart';

class SelectPricingTypeModal extends ConsumerStatefulWidget {
  const SelectPricingTypeModal({super.key});

  @override
  ConsumerState<SelectPricingTypeModal> createState() =>
      _SelectPetCategoryModalState();
}

class _SelectPetCategoryModalState
    extends ConsumerState<SelectPricingTypeModal> {
  @override
  Widget build(BuildContext context) {
    final pricingTypes = ref.watch(pricingTypeProvider);

    return switch (pricingTypes) {
      AsyncData(:final value) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Choose Pricing Type",
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Constants.primaryTextColor
                      : Colors.orange,
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).pop(
                        Lookup(id: value[index].id, name: value[index].name),
                      );
                    },
                    title: Text(value[index].name),
                    subtitle: Text("Charge per ${value[index].name}"),
                  );
                },
              )),
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
