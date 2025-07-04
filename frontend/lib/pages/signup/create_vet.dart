import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/request/create_user_request.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/pages/vet_main_page.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/category_provider.dart';
import 'package:frontend/utils/handle_error.dart';

class CreateVetPage extends ConsumerStatefulWidget {
  final CreateUserRequest reqBody;

  const CreateVetPage({super.key, required this.reqBody});

  @override
  ConsumerState<CreateVetPage> createState() => _CreateVetPageState();
}

class _CreateVetPageState extends ConsumerState<CreateVetPage> {
  final List<int> chosenVetSpecialties = [];

  @override
  Widget build(BuildContext context) {
    final vetSpecialties = ref.watch(vetSpecialtiesProvider);
    AsyncValue<TokenResponse?> auth = ref.watch(authProvider);

    handleError(auth, context, ref.read(authProvider.notifier).reset);

    if (auth.hasValue && !auth.hasError && !auth.isLoading) {
      if (auth.value != null) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => VetMainPage(),
            ),
            (route) => false,
          );
        });
      }
    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.primaryTextColor
                  : Colors.orange,
            ),
          ),
          title: Text(
            AppLocalizations.of(context)!.chooseVetSpecialties,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.primaryTextColor
                  : Colors.orange,
            ),
          ),
          centerTitle: false,
          actions: [
            (!auth.isLoading)
                ? IconButton(
                    onPressed: () async {
                      if (widget.reqBody.vetSpecialtyId.isEmpty) {
                        var snackbar = SnackBar(
                          key: Key("error-message"),
                          content: Text(
                            AppLocalizations.of(context)!
                                .mustChooseOneVetSpecialty,
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red[800],
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        return;
                      }

                      if (!auth.isLoading) {
                        await ref
                            .read(authProvider.notifier)
                            .register(widget.reqBody);
                      }
                    },
                    icon: Icon(
                      Icons.check_rounded,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.primaryTextColor
                          : Colors.orange,
                    ),
                  )
                : CircularProgressIndicator(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Constants.primaryTextColor
                        : Colors.orange,
                  ),
          ],
        ),
        // backgroundColor: Color(0xFFFFF8F0),
        body: switch (vetSpecialties) {
          AsyncError() => ErrorText(
              errorText: AppLocalizations.of(context)!.somethingIsWrongTryAgain,
              onRefresh: () => ref.refresh(vetSpecialtiesProvider.future),
            ),
          AsyncData(:final value) => ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(value[index].name),
                  value:
                      widget.reqBody.vetSpecialtyId.contains(value[index].id),
                  onChanged: (isChecked) {
                    setState(() {
                      if (isChecked == true) {
                        widget.reqBody.vetSpecialtyId.add(value[index].id);
                      } else {
                        widget.reqBody.vetSpecialtyId.remove(value[index].id);
                      }
                    });
                  },
                );
              },
            ),
          _ => Center(child: CircularProgressIndicator()),
        });
  }
}
