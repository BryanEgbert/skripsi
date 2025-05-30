import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/paginated_pets_list_view.dart';
import 'package:frontend/constants.dart';
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
        "Are you sure you want to delete this pet? This action cannot be undone.",
        () => ref.read(petStateProvider.notifier).deletePet(petId));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final petState = ref.watch(petStateProvider);
    // handleValue(petState, this, () {
    //   ref.read(petStateProvider.notifier).reset();
    // });

    // if (_error != null) {
    //   handleError(AsyncValue.error(_error!, StackTrace.current), context);
    //   _error = null;
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pets",
          style: TextStyle(color: Colors.orange),
        ),
        actions: petOwnerAppBarActions(widget.messages.length),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddPetPage(),
          ));
        },
        backgroundColor: Colors.orange,
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
        "Pet category: ${item.petCategory.name}\nStatus: ${item.status}",
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
            icon: Icon(
              Icons.edit,
              color: Colors.orange[600],
            ),
          ),
          IconButton(
            onPressed: () => _deletePet(item.id),
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
