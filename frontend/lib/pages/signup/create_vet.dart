import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/model/request/create_user_request.dart';
import 'package:frontend/model/response/token_response.dart';
import 'package:frontend/pages/vet_page.dart';
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
    log("req: ${widget.reqBody.name}");

    final vetSpecialties = ref.watch(vetSpecialtiesProvider);
    AsyncValue<TokenResponse?> auth = ref.watch(authProvider);

    handleError(auth, context);

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
              icon: Icon(Icons.arrow_back_ios)),
          title: Text(
            "Choose Vet Specialties",
            style: TextStyle(color: Colors.orange),
          ),
          centerTitle: false,
          actions: [
            IconButton(
                onPressed: () async {
                  if (!auth.isLoading) {
                    await ref
                        .read(authProvider.notifier)
                        .register(widget.reqBody);
                  }
                },
                icon: Icon(Icons.check_rounded))
          ],
        ),
        backgroundColor: Color(0xFFFFF8F0),
        body: switch (vetSpecialties) {
          AsyncError(:final error) => ErrorText(
              errorText:
                  "Something is wrong, please try again later\nerror message: $error",
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
                      log("chosenVetSpecialty: ${widget.reqBody.vetSpecialtyId}");
                    });
                  },
                );
              },
            ),
          _ => Center(child: CircularProgressIndicator()),
        });
  }
}
