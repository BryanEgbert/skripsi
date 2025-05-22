import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/components/paginated_vaccine_records_list_view.dart';
import 'package:frontend/model/pet.dart';
import 'package:frontend/pages/add_vaccination_record_page.dart';
import 'package:frontend/pages/edit/edit_pet_details_page.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/pet_provider.dart';
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
      "Are you sure you want to delete this pet? This action cannot be undone.",
      () => ref.read(petStateProvider.notifier).deletePet(widget.petId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pet = ref.watch(petProvider(widget.petId));

    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Constants.secondaryBackgroundColor,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            "Pet Details",
            style: TextStyle(color: Colors.orange),
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
          color: Color(0xFFFFF1E1),
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
                    "Vaccination Records",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
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
                      color: Colors.orange,
                    ),
                  )
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Color(0xFFFFF1E1),
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
    return Container(
      padding: EdgeInsets.all(16),
      color: Color(0xFFFFF1E1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              DefaultCircleAvatar(
                imageUrl: petValue.imageUrl ?? "",
                iconSize: 30,
                circleAvatarRadius: 30,
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    petValue.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  Text("pet category: ${petValue.petCategory.name}"),
                  Text("status: ${petValue.status}"),
                  if (!widget.isOwner) Text("owner: ${petValue.owner.name}"),
                ],
              ),
            ],
          ),
          if (widget.isOwner)
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditPetDetailsPage(
                    petId: widget.petId,
                  ),
                ));
              },
              icon: Icon(
                Icons.edit,
                color: Colors.orange,
              ),
            ),
        ],
      ),
    );
  }
}
