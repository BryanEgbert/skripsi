import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/model/pet_daycare.dart';
import 'package:frontend/model/response/list_response.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:geolocator/geolocator.dart';

final locationEnabledProvider = StateProvider<bool>((ref) => false);

class PetDaycaresView extends ConsumerStatefulWidget {
  const PetDaycaresView({super.key});

  @override
  ConsumerState<PetDaycaresView> createState() => _PetDaycaresViewState();
}

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
    var petDaycares = ref.watch(petDaycaresProvider(_latitude, _longitude));

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
          ...appBarActions(),
        ],
      ),
      body: switch (petDaycares) {
        AsyncData(:final value) => daycareList(value),
        AsyncError(:final error) => ErrorText(
            errorText: error.toString(),
            onRefresh: () =>
                ref.refresh(petDaycaresProvider(_latitude, _longitude).future),
          ),
        _ => Center(
            child: CircularProgressIndicator(),
          ),
      },
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

  Widget daycareList(ListData<PetDaycare> values) {
    return RefreshIndicator(
      onRefresh: () =>
          ref.refresh(petDaycaresProvider(_latitude, _longitude).future),
      child: GridView.builder(
        itemCount: values.data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          mainAxisExtent: 250,
        ),
        itemBuilder: (context, index) {
          var item = values.data[index];
          return Card(
            elevation: 0,
            // color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: InkWell(
              onTap: () {},
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    thumbnail(item),
                    SizedBox(height: 4),
                    Text(
                      item.name,
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "${item.locality} (${(item.distance.toDouble() / 1000).toStringAsFixed(2)}km away)",
                      style: TextStyle(fontSize: 10),
                    ),
                    SizedBox(height: 2),
                    avgRatingWidget(item),
                    SizedBox(height: 4),
                    for (var price in item.prices) priceWidget(price),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  ClipRRect thumbnail(PetDaycare item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Image.network(
        item.thumbnail
            .replaceFirst(RegExp(r'localhost:8080'), "http://10.0.2.2:8080"),
        height: 100,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              color: Colors.grey[400],
              height: 100,
              child: Center(
                child: Icon(Icons.hide_image),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget priceWidget(Price? price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          price!.petCategory.name,
          style: TextStyle(fontSize: 10),
        ),
        Text(
          "Rp. ${price.price}/${price.pricingType}",
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget avgRatingWidget(PetDaycare item) {
    return Row(
      children: [
        Icon(
          Icons.star,
          color: Colors.yellow[700],
          size: 16,
        ),
        Text(
          "${item.averageRating}/5 (${item.ratingCount})",
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
