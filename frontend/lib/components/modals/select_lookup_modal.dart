import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/lookup.dart';
import 'package:frontend/provider/category_provider.dart';

enum LookupCategory {
  dailyWalk,
  dailyPlaytime,
}

class SelectLookupModal extends ConsumerStatefulWidget {
  final LookupCategory lookupCategory;
  const SelectLookupModal(this.lookupCategory, {super.key});

  @override
  ConsumerState<SelectLookupModal> createState() => _SelectLookupModalState();
}

class _SelectLookupModalState extends ConsumerState<SelectLookupModal> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<List<Lookup>> lookup;
    if (widget.lookupCategory == LookupCategory.dailyWalk) {
      lookup = ref.watch(dailyWalksProvider);
    } else {
      lookup = ref.watch(dailyPlaytimesProvider);
    }

    return switch (lookup) {
      AsyncData(:final value) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.lookupCategory == LookupCategory.dailyWalk)
                Text(
                  AppLocalizations.of(context)!.dailyWalksProvided,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Constants.primaryTextColor
                        : Colors.orange,
                  ),
                ),
              if (widget.lookupCategory == LookupCategory.dailyPlaytime)
                Text(
                  AppLocalizations.of(context)!.dailyPlaytimeProvided,
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
                        title: Text(value[index].name),
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
          child: Center(
              child:
                  Text(AppLocalizations.of(context)!.somethingIsWrongTryAgain)),
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
