import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/paginated_pet_daycare_grid_view.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:geolocator/geolocator.dart';

final locationEnabledProvider = StateProvider<bool>((ref) => false);

class PetDaycaresView extends ConsumerStatefulWidget {
  const PetDaycaresView({super.key});

  @override
  ConsumerState<PetDaycaresView> createState() => _PetDaycaresViewState();
}

// TODO: add filter feature
class _PetDaycaresViewState extends ConsumerState<PetDaycaresView> {
  // TODO: change to get location from GPS
  final _latitude = -6.18820656;
  final _longitude = 106.73882456;

  Future<bool> isLocationEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    return serviceEnabled &&
        permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever;
  }

  @override
  // TODO: ask location permission
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: Icon(
              Icons.search_rounded,
            ),
            labelStyle: TextStyle(fontSize: 12),
            isDense: true,
            labelText: "Search pet daycares",
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune_rounded),
            onPressed: () {},
          ),
          ...appBarActions(ref.read(authProvider.notifier)),
        ],
      ),
      body: PaginatedPetDaycareGridView(_latitude, _longitude, pageSize: 10),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info,
              color: Colors.grey,
            ),
            Text(
              "Turn on location to find the nearest pet daycare",
              style: TextStyle(color: Colors.grey[800], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
