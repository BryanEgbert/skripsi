import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/provider/category_provider.dart';
import 'package:frontend/repository/category_service.dart';

class SelectVetSpecialtiesPage extends ConsumerStatefulWidget {
  const SelectVetSpecialtiesPage({super.key});

  @override
  ConsumerState<SelectVetSpecialtiesPage> createState() =>
      _SelectVetSpecialtiesPageState();
}

class _SelectVetSpecialtiesPageState
    extends ConsumerState<SelectVetSpecialtiesPage> {
  List<int> vetSpecialtiesId = [];

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Lookup>> vetSpecialties =
        ref.read(vetSpecialtiesProvider(CategoryService()));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select specialties"),
      ),
      body: switch (vetSpecialties) {
        AsyncData(:final value) => ListView.builder(
            itemBuilder: (context, index) {
              return CheckboxListTile(
                title: Text(value[index].name),
                value: vetSpecialtiesId.contains(value[index].id),
                onChanged: (bool? v) {
                  vetSpecialtiesId.add(value[index].id);
                  setState(() {});
                },
              );
            },
          ),
        AsyncError() => const Text("Something's wrong"),
        _ => const CircularProgressIndicator(),
      },
    );
  }
}
