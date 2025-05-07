import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/pet_daycare.dart';
import 'package:frontend/model/request/pet_daycare_filters.dart';
import 'package:frontend/pages/details/pet_daycare_details_page.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/list_data_provider.dart';
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
  double? _latitude;
  double? _longitude;

  final ScrollController _scrollController = ScrollController();
  List<PetDaycare> _records = [];

  int _lastId = 0;
  bool _isFetching = false;
  bool _hasMoreData = true;

  bool _serviceEnabled = false;
  LocationPermission _permission = LocationPermission.denied;

  PetDaycareFilters filters = PetDaycareFilters();

  Object? _error;

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetching) {
      _fetchMoreData();
    }
  }

  void _fetchMoreData() {
    if (!_hasMoreData) return; // Stop fetching if no more data

    setState(() => _isFetching = true);

    ref
        .read(petDaycaresProvider(
      _latitude,
      _longitude,
      _lastId,
      10,
      filters.minDistance,
      filters.maxDistance,
      filters.facilities,
      filters.mustBeVaccinated,
      filters.dailyWalks,
      filters.dailyPlaytime,
      filters.minPrice,
      filters.maxPrice,
      filters.pricingType,
    ).future)
        .then((newData) {
      if (newData.data.isNotEmpty) {
        setState(() {
          _records.addAll(newData.data);
          _lastId = newData.data.last.id;
        });
      } else {
        setState(() {
          _hasMoreData = false;
        });
      }
    }).catchError((e) {
      _error = e;
    }).whenComplete(() => setState(() => _isFetching = false));
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
    _scrollController.addListener(_onScroll);
    _fetchMoreData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    _permission = await Geolocator.checkPermission();

    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (_permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position currentPos = await Geolocator.getCurrentPosition();

    _latitude = currentPos.latitude;
    _longitude = currentPos.longitude;
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return ErrorText(
          errorText: _error.toString(),
          onRefresh: () async {
            _records = [];
            _lastId = 0;
            _fetchMoreData();
          });
    }

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
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          ...appBarActions(ref.read(authProvider.notifier)),
        ],
      ),
      drawer: Stack(
        children: [
          Column(
            children: [
              Text(
                "Pet Vaccination",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              FilterChip(
                label: Text("Require Pet Vaccination"),
                selected: filters.mustBeVaccinated ?? false,
                onSelected: (value) {
                  if (value == true) {
                    filters.mustBeVaccinated = value;
                  } else {
                    filters.mustBeVaccinated = null;
                  }
                },
              ),
              Text("Distance in kilometer (GPS must be turned on)"),
              Text(
                "To disable filter by distance, set slider to 0",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              RangeSlider(
                max: 500,
                min: 0,
                divisions: 500,
                labels: RangeLabels(
                  "${filters.minDistance.round()} km",
                  "${filters.maxDistance.round()} km",
                ),
                values: RangeValues(filters.minDistance, filters.maxDistance),
                onChanged: _serviceEnabled
                    ? (value) {
                        filters.minDistance = value.start;
                        filters.maxDistance = value.end;
                      }
                    : null,
                activeColor: Constants.primaryTextColor,
              ),
              Text("Price Range"),
              Text(
                "To disable price range filter, set slider to 0",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              RangeSlider(
                max: 1000000,
                min: 0,
                divisions: 100000,
                labels: RangeLabels(
                  "Rp${filters.minPrice.round()}",
                  "Rp${filters.maxPrice.round()}",
                ),
                values: RangeValues(filters.minPrice, filters.maxPrice),
                onChanged: (value) {
                  filters.minPrice = value.start;
                  filters.maxPrice = value.end;
                },
                activeColor: Constants.primaryTextColor,
              ),
              Text("Facilities"),
              Row(
                children: [
                  FilterChip(
                    selected: filters.facilities.contains("pickup"),
                    label: Text("Pick-Up Service Provided"),
                    onSelected: (value) {
                      if (value == true) {
                        filters.facilities.add("pickup");
                      } else {
                        filters.facilities.remove("pickup");
                      }
                    },
                  ),
                  FilterChip(
                    selected: filters.facilities.contains("food"),
                    label: Text("Food Provided"),
                    onSelected: (value) {
                      if (value == true) {
                        filters.facilities.add("food");
                      } else {
                        filters.facilities.remove("food");
                      }
                    },
                  ),
                  FilterChip(
                    selected: filters.facilities.contains("grooming"),
                    label: Text("Grooming Service Provided"),
                    onSelected: (value) {
                      if (value == true) {
                        filters.facilities.add("grooming");
                      } else {
                        filters.facilities.remove("grooming");
                      }
                    },
                  ),
                ],
              ),
              Text("Daily Walks"),
              Row(
                children: [
                  FilterChip(
                    selected: filters.dailyWalks == 1,
                    label: Text("No Walks Provided"),
                    onSelected: (value) {
                      if (value == true) {
                        filters.dailyWalks = 1;
                      }
                    },
                  ),
                  FilterChip(
                    selected: filters.dailyWalks == 2,
                    label: Text("One Walk a Day"),
                    onSelected: (value) {
                      if (value == true) {
                        filters.dailyWalks = 2;
                      }
                    },
                  ),
                  FilterChip(
                    selected: filters.dailyWalks == 3,
                    label: Text("Two Walks a Day"),
                    onSelected: (value) {
                      if (value == true) {
                        filters.dailyWalks = 3;
                      }
                    },
                  ),
                  FilterChip(
                    selected: filters.dailyWalks == 4,
                    label: Text("More Than Two Walks a Day"),
                    onSelected: (value) {
                      if (value == true) {
                        filters.dailyWalks = 4;
                      }
                    },
                  ),
                ],
              ),
              Text("Daily Playtime"),
              Row(
                children: [
                  FilterChip(
                    selected: filters.dailyPlaytime == 1,
                    label: Text("No Playtime Provided"),
                    onSelected: (value) {
                      if (value == true) {
                        filters.dailyPlaytime = 1;
                      }
                    },
                  ),
                  FilterChip(
                    selected: filters.dailyPlaytime == 2,
                    label: Text("One Play Session a Day"),
                    onSelected: (value) {
                      if (value == true) {
                        filters.dailyPlaytime = 2;
                      }
                    },
                  ),
                  FilterChip(
                    selected: filters.dailyPlaytime == 3,
                    label: Text("Two Play Session a Day"),
                    onSelected: (value) {
                      if (value == true) {
                        filters.dailyPlaytime = 3;
                      }
                    },
                  ),
                  FilterChip(
                    selected: filters.dailyPlaytime == 4,
                    label: Text("More Than Two Play Session a Day"),
                    onSelected: (value) {
                      if (value == true) {
                        filters.dailyPlaytime = 4;
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (filters == PetDaycareFilters()) {
                return;
              }

              Navigator.of(context).pop();
              setState(() {});
            },
            child: Text("Save"),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _records = [];
          _lastId = 0;
          _fetchMoreData();
        },
        child: (_isFetching && _records.isEmpty)
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.orange,
              ))
            : GridView.builder(
                itemCount: _records.length + 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 0.0,
                  mainAxisExtent: 250,
                ),
                itemBuilder: (context, index) {
                  if (index < _records.length) {
                    return _buildCard(context, _records[index]);
                  } else {
                    if (_isFetching) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: Colors.orange,
                      ));
                    }

                    return SizedBox();
                  }
                },
              ),
      ),
      bottomSheet: _serviceEnabled == false
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                  TextButton(
                    onPressed: () async {
                      await Geolocator.openLocationSettings();
                    },
                    child: Text(
                      "Turn On Location",
                      style: TextStyle(color: Colors.grey[800], fontSize: 12),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildCard(BuildContext context, PetDaycare item) {
    return Card(
      elevation: 0,
      // color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PetDaycareDetailsPage(item.id),
          ));
        },
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
  }

  Widget thumbnail(PetDaycare item) {
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
