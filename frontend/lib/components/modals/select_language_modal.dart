import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/provider/locale_provider.dart';

class SelectLanguageModal extends ConsumerStatefulWidget {
  const SelectLanguageModal({
    super.key,
  });

  @override
  ConsumerState<SelectLanguageModal> createState() =>
      _SelectLanguageModalState();
}

class _SelectLanguageModalState extends ConsumerState<SelectLanguageModal> {
  @override
  Widget build(BuildContext context) {
    final localeState = ref.watch(localeStateProvider);
    return switch (localeState) {
      AsyncError(:final error) => ErrorText(
          errorText: error.toString(),
          onRefresh: () => ref.refresh(localeStateProvider.future)),
      AsyncData(:final value) => Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.choosePreferredLanguage,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Constants.primaryTextColor
                      : Colors.orange,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: AppLocalizations.supportedLocales.length,
                  itemBuilder: (context, index) {
                    return RadioListTile.adaptive(
                      value: AppLocalizations.supportedLocales[index]
                          .toLanguageTag(),
                      groupValue: value,
                      onChanged: (value) {
                        if (value == null) return;
                        ref.read(localeStateProvider.notifier).set(value);
                        Navigator.of(context).pop();
                      },
                      title: Text(
                        AppLocalizations.supportedLocales[index]
                            .toLanguageTag()
                            .toUpperCase(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      _ => Center(child: CircularProgressIndicator.adaptive())
    };
  }
}
