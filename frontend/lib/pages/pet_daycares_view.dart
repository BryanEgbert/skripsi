import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/chat_message.dart';
import 'package:frontend/model/pet_daycare.dart';
import 'package:frontend/model/request/pet_daycare_filters.dart';
import 'package:frontend/pages/details/pet_daycare_details_page.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:geolocator/geolocator.dart';

final locationEnabledProvider = StateProvider<bool>((ref) => false);

class PetDaycaresView extends ConsumerStatefulWidget {
  final List<ChatMessage> messages;
  const PetDaycaresView(this.messages, {super.key});

  @override
  ConsumerState<PetDaycaresView> createState() => _PetDaycaresViewState();
}

class _PetDaycaresViewState extends ConsumerState<PetDaycaresView> {
  double? _latitude, _longitude;

  final ScrollController _scrollController = ScrollController();
  List<PetDaycare> _records = [];

  int _lastId = 0;
  bool _isFetching = false;
  bool _hasMoreData = true;

  bool _serviceEnabled = false;
  LocationPermission _permission = LocationPermission.denied;

  final List<String> _serviceFeatures = [];

  final PetDaycareFilters _filters = PetDaycareFilters();

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
      _filters.minDistance,
      _filters.maxDistance,
      _serviceFeatures,
      _filters.mustBeVaccinated,
      _filters.dailyWalks,
      _filters.dailyPlaytime,
      _filters.minPrice,
      _filters.maxPrice,
      _filters.pricingType,
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
    log("filter: $_filters");
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
          Builder(builder: (context) {
            return IconButton(
              icon: Icon(Icons.tune_rounded),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          }),
          ...petOwnerAppBarActions(widget.messages.length),
        ],
      ),
      endDrawer: Container(
        padding: EdgeInsets.all(12),
        color: Theme.of(context).brightness == Brightness.light
            ? Constants.secondaryBackgroundColor
            : Constants.darkBackgroundColor,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.navigate_before,
                        color: Constants.primaryTextColor,
                      ),
                    ),
                    Text(
                      "Back",
                      style: TextStyle(color: Constants.primaryTextColor),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pet Vaccination",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.primaryTextColor,
                      ),
                    ),
                    FilterChip(
                      label: Text(
                        "Require Pet Vaccination",
                        style: TextStyle(fontSize: 12),
                      ),
                      selected: _filters.mustBeVaccinated ?? false,
                      onSelected: (value) {
                        if (value == true) {
                          setState(() {
                            _filters.mustBeVaccinated = value;
                          });
                        } else {
                          setState(() {
                            _filters.mustBeVaccinated = null;
                          });
                        }
                      },
                    ),
                    Text(
                      "Distance in kilometer (GPS must be turned on)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.primaryTextColor,
                      ),
                    ),
                    Text(
                      "To disable filter by distance, set slider to 0",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[700]
                            : null,
                      ),
                    ),
                    RangeSlider(
                      max: 500,
                      min: 0,
                      divisions: 500,
                      labels: RangeLabels(
                        "${_filters.minDistance.round()} km",
                        "${_filters.maxDistance.round()} km",
                      ),
                      values: RangeValues(
                          _filters.minDistance, _filters.maxDistance),
                      onChanged: _serviceEnabled
                          ? (value) {
                              setState(() {
                                _filters.minDistance = value.start;
                                _filters.maxDistance = value.end;
                              });
                            }
                          : null,
                      activeColor: Constants.primaryTextColor,
                    ),
                    Text(
                      "Price Range",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.primaryTextColor,
                      ),
                    ),
                    Text(
                      "To disable price range filter, set slider to 0",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[700]
                            : null,
                      ),
                    ),
                    RangeSlider(
                      max: 1000000,
                      min: 0,
                      divisions: 100000,
                      labels: RangeLabels(
                        "Rp${_filters.minPrice.round()}",
                        "Rp${_filters.maxPrice.round()}",
                      ),
                      values: RangeValues(_filters.minPrice, _filters.maxPrice),
                      onChanged: (value) {
                        setState(() {
                          _filters.minPrice = value.start;
                          _filters.maxPrice = value.end;
                        });
                      },
                      activeColor: Constants.primaryTextColor,
                    ),
                    Text(
                      "Facilities",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.primaryTextColor,
                      ),
                    ),
                    Wrap(
                      spacing: 4,
                      children: [
                        FilterChip(
                          selected: _serviceFeatures.contains("pickup"),
                          label: Text(
                            "Pick-Up Service Provided",
                            style: TextStyle(fontSize: 12),
                          ),
                          onSelected: (value) {
                            if (value == true) {
                              setState(() {
                                _serviceFeatures.add("pickup");
                              });
                            } else {
                              setState(() {
                                _serviceFeatures.remove("pickup");
                              });
                            }
                          },
                        ),
                        FilterChip(
                          selected: _serviceFeatures.contains("food"),
                          label: Text(
                            "Food Provided",
                            style: TextStyle(fontSize: 12),
                          ),
                          onSelected: (value) {
                            setState(() {
                              if (value == true) {
                                _serviceFeatures.add("food");
                              } else {
                                _serviceFeatures.remove("food");
                              }
                            });
                          },
                        ),
                        FilterChip(
                          selected: _serviceFeatures.contains("grooming"),
                          label: Text(
                            "Grooming Service Provided",
                            style: TextStyle(fontSize: 12),
                          ),
                          onSelected: (value) {
                            setState(() {
                              if (value == true) {
                                _serviceFeatures.add("grooming");
                              } else {
                                _serviceFeatures.remove("grooming");
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    Text(
                      "Daily Walks",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.primaryTextColor,
                      ),
                    ),
                    Wrap(
                      spacing: 4,
                      children: [
                        FilterChip(
                          selected: _filters.dailyWalks == 1,
                          label: Text(
                            "No Walks Provided",
                            style: TextStyle(fontSize: 12),
                          ),
                          onSelected: (value) {
                            if (value == true) {
                              setState(() {
                                _filters.dailyWalks = 1;
                              });
                            }
                          },
                        ),
                        FilterChip(
                          selected: _filters.dailyWalks == 2,
                          label: Text(
                            "One Walk a Day",
                            style: TextStyle(fontSize: 12),
                          ),
                          onSelected: (value) {
                            if (value == true) {
                              setState(() {
                                _filters.dailyWalks = 2;
                              });
                            }
                          },
                        ),
                        FilterChip(
                          selected: _filters.dailyWalks == 3,
                          label: Text(
                            "Two Walks a Day",
                            style: TextStyle(fontSize: 12),
                          ),
                          onSelected: (value) {
                            if (value == true) {
                              setState(() {
                                _filters.dailyWalks = 3;
                              });
                            }
                          },
                        ),
                        FilterChip(
                          selected: _filters.dailyWalks == 4,
                          label: Text(
                            "More Than Two Walks a Day",
                            style: TextStyle(fontSize: 12),
                          ),
                          onSelected: (value) {
                            if (value == true) {
                              setState(() {
                                _filters.dailyWalks = 4;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    Text(
                      "Daily Playtime",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.primaryTextColor,
                      ),
                    ),
                    Wrap(
                      spacing: 4,
                      children: [
                        FilterChip(
                          selected: _filters.dailyPlaytime == 1,
                          label: Text(
                            "No Playtime Provided",
                            style: TextStyle(fontSize: 12),
                          ),
                          onSelected: (value) {
                            if (value == true) {
                              setState(() {
                                _filters.dailyPlaytime = 1;
                              });
                            }
                          },
                        ),
                        FilterChip(
                          selected: _filters.dailyPlaytime == 2,
                          label: Text(
                            "One Play Session a Day",
                            style: TextStyle(fontSize: 12),
                          ),
                          onSelected: (value) {
                            if (value == true) {
                              _filters.dailyPlaytime = 2;
                            }
                          },
                        ),
                        FilterChip(
                          selected: _filters.dailyPlaytime == 3,
                          label: Text(
                            "Two Play Session a Day",
                            style: TextStyle(fontSize: 12),
                          ),
                          onSelected: (value) {
                            if (value == true) {
                              setState(() {
                                _filters.dailyPlaytime = 3;
                              });
                            }
                          },
                        ),
                        FilterChip(
                          selected: _filters.dailyPlaytime == 4,
                          label: Text(
                            "More Than Two Play Session a Day",
                            style: TextStyle(fontSize: 12),
                          ),
                          onSelected: (value) {
                            if (value == true) {
                              setState(() {
                                _filters.dailyPlaytime = 4;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _records = [];
                      _lastId = 0;
                      _fetchMoreData();
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      textStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  child: Text("Save"),
                )
              ],
            ),
          ),
        ),
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
                        style: TextStyle(color: Colors.grey[800], fontSize: 11),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () async {
                      await Geolocator.openLocationSettings();
                    },
                    child: Text(
                      "Turn On",
                      style: TextStyle(
                          color: Constants.primaryTextColor, fontSize: 11),
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
