import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/components/paginated_vaccine_records_list_view.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/pet.dart';
import 'package:frontend/pages/add_vaccination_record_page.dart';
import 'package:frontend/pages/edit/edit_pet_details_page.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/pet_provider.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/show_confirmation_dialog.dart';

class PetDetailsPage extends ConsumerStatefulWidget {
  final int petId;
  final bool isOwner;

  const PetDetailsPage({
    super.key,
    required this.petId,
    required this.isOwner,
  });

  @override
  ConsumerState<PetDetailsPage> createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends ConsumerState<PetDetailsPage> {
  void _deletePet() {
    showDeleteConfirmationDialog(
      context,
      AppLocalizations.of(context)!.deletePetConfirmation,
      () => ref.read(petStateProvider.notifier).deletePet(widget.petId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pet = ref.watch(petProvider(widget.petId));
    final petState = ref.watch(petStateProvider);

    log("[PET DETAILS PAGE] petState: $petState");
    handleValue(petState, this, ref.read(petStateProvider.notifier).reset);

    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Constants.secondaryBackgroundColor,
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
            AppLocalizations.of(context)!.petDetails,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.primaryTextColor
                  : Colors.orange,
            ),
          ),
          actions: (widget.isOwner)
              ? [
                  IconButton(
                      onPressed: _deletePet,
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))
                ]
              : null,
        ),
        body: switch (pet) {
          AsyncError(:final error) => ErrorText(
              errorText: error.toString(),
              onRefresh: () => ref.refresh(petProvider(widget.petId).future),
            ),
          AsyncData(:final value) => _buildBody(value),
          _ => Center(
              child: CircularProgressIndicator.adaptive(),
            ),
        });
  }

  Widget _buildBody(Pet petValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPetDetails(petValue),
        SizedBox(height: 8),
        Container(
          color: Theme.of(context).brightness == Brightness.light
              ? Constants.secondaryBackgroundColor
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: (!widget.isOwner)
                      ? const EdgeInsets.only(top: 8.0)
                      : null,
                  child: Text(
                    AppLocalizations.of(context)!.vaccinationRecords,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.primaryTextColor
                          : Colors.orange,
                    ),
                  ),
                ),
                if (widget.isOwner)
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AddVaccinationRecordPage(widget.petId),
                      ));
                    },
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.primaryTextColor
                          : Colors.orange,
                    ),
                  )
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Theme.of(context).brightness == Brightness.light
                ? Constants.secondaryBackgroundColor
                : null,
            child: PaginatedVaccineRecordsListView(
              widget.petId,
              pageSize: 10,
              isOwner: widget.isOwner,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPetDetails(Pet petValue) {
    return ListTile(
      tileColor: Theme.of(context).brightness == Brightness.light
          ? Constants.secondaryBackgroundColor
          : null,
      leading: DefaultCircleAvatar(
        imageUrl: petValue.imageUrl ?? "",
        iconSize: 30,
        circleAvatarRadius: 30,
      ),
      title: Text(petValue.name),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).brightness == Brightness.light
            ? Constants.primaryTextColor
            : Colors.orange,
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!
                .petCategory(petValue.petCategory.name),
          ),
          if (!widget.isOwner)
            Text(
              AppLocalizations.of(context)!.petOwner(petValue.owner.name),
            ),
        ],
      ),
      trailing: widget.isOwner
          ? IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditPetDetailsPage(
                    petId: widget.petId,
                  ),
                ));
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).brightness == Brightness.light
                    ? Constants.primaryTextColor
                    : Colors.orange,
              ),
            )
          : null,
    );
  }
}
