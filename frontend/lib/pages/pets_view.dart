import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/paginated_pets_list_view.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/chat_message.dart';
import 'package:frontend/model/pet.dart';
import 'package:frontend/pages/add_pet_page.dart';
import 'package:frontend/pages/details/pet_details_page.dart';
import 'package:frontend/pages/edit/edit_pet_details_page.dart';
import 'package:frontend/provider/pet_provider.dart';
import 'package:frontend/utils/show_confirmation_dialog.dart';

class PetsView extends ConsumerStatefulWidget {
  final List<ChatMessage> messages;
  const PetsView(this.messages, {super.key});

  @override
  ConsumerState<PetsView> createState() => _PetsViewState();
}

class _PetsViewState extends ConsumerState<PetsView> {
  // String? _error;

  void _deletePet(int petId) {
    showDeleteConfirmationDialog(
        context,
        AppLocalizations.of(context)!.deletePetConfirmation,
        () => ref.read(petStateProvider.notifier).deletePet(petId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.petsTitle,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Constants.primaryTextColor
                : Colors.orange,
          ),
        ),
        actions: petOwnerAppBarActions(widget.messages.length),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddPetPage(),
          ));
        },
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Constants.primaryTextColor
            : Colors.orange,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: PaginatedPetsListView(
        pageSize: 10,
        buildBody: _buildListTile,
      ),
    );
  }

  Widget _buildListTile(Pet item) {
    return ListTile(
      leading: DefaultCircleAvatar(imageUrl: item.imageUrl ?? ""),
      title: Text(
        item.name,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light
              ? Constants.primaryTextColor
              : Colors.orange,
        ),
      ),
      subtitle: Text(
        AppLocalizations.of(context)!.petCategory(item.petCategory.name),
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white70,
        ),
      ),
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.orange,
      ),
      subtitleTextStyle: TextStyle(
        fontSize: 14,
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white70,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditPetDetailsPage(petId: item.id),
              ));
            },
            tooltip: AppLocalizations.of(context)!.editPetTooltip,
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.primaryTextColor
                  : Colors.orange,
            ),
          ),
          IconButton(
            onPressed: () => _deletePet(item.id),
            tooltip: AppLocalizations.of(context)!.deletePetTooltip,
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PetDetailsPage(
              petId: item.id,
              isOwner: true,
            ),
          ),
        );
      },
    );
  }
}
