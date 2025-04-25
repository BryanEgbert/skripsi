import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/paginated_pets_list_view.dart';
import 'package:frontend/model/pet.dart';
import 'package:frontend/pages/details/pet_details_page.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/pet_provider.dart';

class PetsView extends ConsumerStatefulWidget {
  const PetsView({super.key});

  @override
  ConsumerState<PetsView> createState() => _PetsViewState();
}

class _PetsViewState extends ConsumerState<PetsView> {
  void _deletePet(int petId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
              "Are you sure you want to delete this pet? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                ref.read(petStateProvider.notifier).deletePet(petId);
                Navigator.of(context).pop();
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pets",
          style: TextStyle(color: Colors.orange),
        ),
        actions: appBarActions(ref.read(authProvider.notifier)),
      ),
      // TODO: add create pet
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
      title: Text(item.name),
      subtitle: Text(
          "Pet category: ${item.petCategory.name}\nStatus: ${item.status}"),
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.orange,
      ),
      subtitleTextStyle: TextStyle(fontSize: 14, color: Colors.black),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // TODO: edit pet
          IconButton(
            onPressed: () {},
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
