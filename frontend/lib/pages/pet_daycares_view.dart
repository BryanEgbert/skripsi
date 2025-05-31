import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/chat_message.dart';
import 'package:frontend/model/pet_daycare.dart';
import 'package:frontend/model/request/pet_daycare_filters.dart';
import 'package:frontend/pages/details/pet_daycare_details_page.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

final locationEnabledProvider = StateProvider<bool>((ref) => false);

class PetDaycaresView extends ConsumerStatefulWidget {
  final List<ChatMessage> messages;
  const PetDaycaresView(this.messages, {super.key});

  @override
  ConsumerState<PetDaycaresView> createState() => _PetDaycaresViewState();
}

class _PetDaycaresViewState extends ConsumerState<PetDaycaresView> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _serviceFeatures = [];

  final _minDistanceController = TextEditingController();
  final _maxDistanceController = TextEditingController();

  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();

  final rupiahFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  double? _latitude, _longitude;

  List<PetDaycare> _records = [];

  int _page = 1;
  bool _isFetching = false;
  bool _hasMoreData = true;

  String? _minDistanceError;
  String? _maxDistanceError;
  String? _minPriceError;
  String? _maxPriceError;

  bool _serviceEnabled = false;
  LocationPermission _permission = LocationPermission.denied;

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
      _page,
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
          _page += 1;
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

    _minDistanceController.text = _filters.minDistance.toInt().toString();
    _maxDistanceController.text = _filters.maxDistance.toInt().toString();

    _minPriceController.text = rupiahFormat.format(_filters.minPrice);
    _maxPriceController.text = rupiahFormat.format(_filters.maxPrice);
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
      handleError(AsyncError(_error!, StackTrace.current), context);
    }

    return Scaffold(
      appBar: AppBar(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
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
                          Wrap(
                            spacing: 4,
                            children: [
                              FilterChip(
                                label: Text(
                                  "Requires Vaccination",
                                  style: TextStyle(fontSize: 12),
                                ),
                                selected: _filters.mustBeVaccinated == true,
                                onSelected: (value) {
                                  setState(() {
                                    _filters.mustBeVaccinated =
                                        value ? true : null;
                                  });
                                },
                              ),
                              FilterChip(
                                label: Text(
                                  "Doesn't Require Vaccination",
                                  style: TextStyle(fontSize: 12),
                                ),
                                selected: _filters.mustBeVaccinated == false,
                                onSelected: (value) {
                                  setState(() {
                                    _filters.mustBeVaccinated =
                                        value ? false : null;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
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
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.grey[700]
                                  : Colors.white70,
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
                                      _minDistanceController.text =
                                          value.start.toInt().toString();
                                      _maxDistanceController.text =
                                          value.end.toInt().toString();
                                    });
                                  }
                                : null,
                            activeColor: Constants.primaryTextColor,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 8,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _minDistanceController,
                                  decoration: InputDecoration(
                                    labelText: "min distance",
                                    labelStyle: TextStyle(fontSize: 14),
                                    suffixText: "km",
                                    suffixStyle: TextStyle(fontSize: 14),
                                    errorText: _minDistanceError,
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (value) {
                                    _minDistanceError = null;
                                    if (value.isEmpty) {
                                      _minDistanceController.text = "0";
                                    } else {
                                      _minDistanceController.text =
                                          int.parse(value).toString();
                                    }
                                    double parsed =
                                        int.parse(_minDistanceController.text)
                                            .toDouble();
                                    if (parsed < 0) {
                                      _minDistanceController.text = "0";
                                    }

                                    if (parsed > _filters.maxDistance) {
                                      _minDistanceController.text =
                                          _filters.maxDistance.toString();
                                    }

                                    if (parsed > 500) {
                                      _minDistanceController.text = "500";
                                    }
                                    setState(() {
                                      _filters.minDistance =
                                          int.parse(_minDistanceController.text)
                                              .toDouble();
                                    });
                                  },
                                ),
                              ),
                              Text("-"),
                              Expanded(
                                child: TextField(
                                  controller: _maxDistanceController,
                                  decoration: InputDecoration(
                                      labelText: "max distance",
                                      labelStyle: TextStyle(fontSize: 14),
                                      suffixText: "km",
                                      suffixStyle: TextStyle(fontSize: 14),
                                      errorText: _maxDistanceError),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (value) {
                                    _maxDistanceError = null;
                                    if (value.isEmpty) {
                                      _maxDistanceController.text = "0";
                                    } else {
                                      _maxDistanceController.text =
                                          int.parse(value).toString();
                                    }

                                    double parsed =
                                        int.parse(_maxDistanceController.text)
                                            .toDouble();
                                    if (parsed < 0) {
                                      _maxDistanceController.text = "0";
                                    }
                                    if (parsed < _filters.minDistance) {
                                      _maxDistanceController.text = _filters
                                          .minDistance
                                          .round()
                                          .toString();
                                    }
                                    if (parsed > 500) {
                                      _maxDistanceController.text = "500";
                                    }
                                    setState(() {
                                      _filters.maxDistance =
                                          int.parse(_maxDistanceController.text)
                                              .toDouble();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
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
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.grey[700]
                                  : Colors.white70,
                            ),
                          ),
                          RangeSlider(
                            max: 1000000,
                            min: 0,
                            divisions: 100000,
                            labels: RangeLabels(
                              rupiahFormat.format(_filters.minPrice),
                              rupiahFormat.format(_filters.maxPrice),
                            ),
                            values: RangeValues(
                                _filters.minPrice, _filters.maxPrice),
                            onChanged: (value) {
                              setState(() {
                                _filters.minPrice = value.start;
                                _filters.maxPrice = value.end;
                                _minPriceController.text =
                                    rupiahFormat.format(value.start);
                                _maxPriceController.text =
                                    rupiahFormat.format(value.end);
                              });
                            },
                            activeColor: Constants.primaryTextColor,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 8,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _minPriceController,
                                  decoration: InputDecoration(
                                      labelText: "min price",
                                      labelStyle: TextStyle(fontSize: 14),
                                      errorText: _minPriceError),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (value) {
                                    _minPriceError = null;

                                    String digitsOnly =
                                        value.replaceAll(RegExp(r'[^0-9]'), '');
                                    if (digitsOnly.isEmpty) digitsOnly = '0';

                                    if (digitsOnly.isEmpty) {
                                      _minPriceController.text =
                                          rupiahFormat.format(0);
                                    }

                                    double parsed =
                                        int.parse(_minPriceController.text)
                                            .toDouble();
                                    _minPriceController.text =
                                        rupiahFormat.format(parsed);

                                    if (parsed < 0) {
                                      _minPriceController.text =
                                          rupiahFormat.format(0);
                                    }

                                    if (parsed > _filters.maxPrice) {
                                      _minPriceController.text = rupiahFormat
                                          .format(_filters.maxPrice);
                                    }
                                    if (parsed > 1000000) {
                                      _minPriceController.text =
                                          rupiahFormat.format(1000000);
                                    }
                                    setState(() {
                                      String digitsOnly = value.replaceAll(
                                          RegExp(r'[^0-9]'), '');
                                      _filters.minPrice =
                                          int.parse(digitsOnly).toDouble();
                                      log("change: ${_filters.minPrice}");
                                    });
                                  },
                                ),
                              ),
                              Text("-"),
                              Expanded(
                                child: TextField(
                                  controller: _maxPriceController,
                                  decoration: InputDecoration(
                                    labelText: "max price",
                                    labelStyle: TextStyle(fontSize: 14),
                                    errorText: _maxPriceError,
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (value) {
                                    _maxPriceError = null;
                                    String digitsOnly =
                                        value.replaceAll(RegExp(r'[^0-9]'), '');
                                    if (digitsOnly.isEmpty) digitsOnly = '0';

                                    if (digitsOnly.isEmpty) {
                                      _maxPriceController.text =
                                          rupiahFormat.format(0);
                                    }
                                    double parsed =
                                        int.parse(digitsOnly).toDouble();
                                    _maxPriceController.text =
                                        rupiahFormat.format(parsed);

                                    if (parsed < 0) {
                                      _maxPriceController.text =
                                          rupiahFormat.format(0);
                                    }
                                    if (parsed < _filters.minPrice) {
                                      _maxPriceController.text = rupiahFormat
                                          .format(_filters.minPrice);
                                    }
                                    if (parsed > 1000000) {
                                      _maxPriceController.text =
                                          rupiahFormat.format(1000000);
                                    }
                                    setState(() {
                                      String digitsOnly = _maxPriceController
                                          .text
                                          .replaceAll(RegExp(r'[^0-9]'), '');
                                      _filters.maxPrice =
                                          int.parse(digitsOnly).toDouble();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
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
                                  "In-House Food Provided",
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
                          const SizedBox(height: 4),
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
                                  setState(() {
                                    _filters.dailyWalks = value ? 1 : 0;
                                  });
                                },
                              ),
                              FilterChip(
                                selected: _filters.dailyWalks == 2,
                                label: Text(
                                  "One Walk a Day",
                                  style: TextStyle(fontSize: 12),
                                ),
                                onSelected: (value) {
                                  setState(() {
                                    _filters.dailyWalks = value ? 2 : 0;
                                  });
                                },
                              ),
                              FilterChip(
                                selected: _filters.dailyWalks == 3,
                                label: Text(
                                  "Two Walks a Day",
                                  style: TextStyle(fontSize: 12),
                                ),
                                onSelected: (value) {
                                  setState(() {
                                    _filters.dailyWalks = value ? 3 : 0;
                                  });
                                },
                              ),
                              FilterChip(
                                selected: _filters.dailyWalks == 4,
                                label: Text(
                                  "More Than Two Walks a Day",
                                  style: TextStyle(fontSize: 12),
                                ),
                                onSelected: (value) {
                                  setState(() {
                                    _filters.dailyWalks = value ? 4 : 0;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
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
                                  setState(() {
                                    _filters.dailyPlaytime = value ? 1 : 0;
                                  });
                                },
                              ),
                              FilterChip(
                                selected: _filters.dailyPlaytime == 2,
                                label: Text(
                                  "One Play Session a Day",
                                  style: TextStyle(fontSize: 12),
                                ),
                                onSelected: (value) {
                                  setState(() {
                                    _filters.dailyPlaytime = value ? 2 : 0;
                                  });
                                },
                              ),
                              FilterChip(
                                selected: _filters.dailyPlaytime == 3,
                                label: Text(
                                  "Two Play Session a Day",
                                  style: TextStyle(fontSize: 12),
                                ),
                                onSelected: (value) {
                                  setState(() {
                                    _filters.dailyPlaytime = value ? 3 : 0;
                                  });
                                },
                              ),
                              FilterChip(
                                selected: _filters.dailyPlaytime == 4,
                                label: Text(
                                  "More Than Two Play Session a Day",
                                  style: TextStyle(fontSize: 12),
                                ),
                                onSelected: (value) {
                                  setState(() {
                                    _filters.dailyPlaytime = value ? 4 : 0;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      // const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
            if (_minDistanceError == null &&
                _maxDistanceError == null &&
                _minPriceError == null &&
                _maxPriceError == null)
              ElevatedButton(
                onPressed: () {
                  if (_minDistanceError != null ||
                      _maxDistanceError != null ||
                      _minPriceError != null ||
                      _maxPriceError != null) {
                    return;
                  }
                  setState(() {
                    _records = [];
                    _page = 1;
                    _hasMoreData = true;
                    _fetchMoreData();
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    textStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                child: Text("Apply Filter"),
              )
          ],
        ),
      ),
      body: (_error != null)
          ? ErrorText(
              errorText: _error.toString(),
              onRefresh: () async {
                _records = [];
                _page = 1;
                _hasMoreData = true;
                _fetchMoreData();
              })
          : RefreshIndicator.adaptive(
              onRefresh: () async {
                _records = [];
                _page = 1;
                _hasMoreData = true;
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
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[800]
                            : Colors.white70,
                      ),
                      Text(
                        "Turn on location to find the nearest pet daycare",
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.grey[800]
                                  : Colors.white70,
                          fontSize: 11,
                        ),
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
                        color: Theme.of(context).brightness == Brightness.light
                            ? Constants.primaryTextColor
                            : Colors.orange,
                      ),
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
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Constants.primaryTextColor
                      : Colors.orange,
                ),
              ),
              Text(
                "${item.locality} (${(item.distance.toDouble() / 1000).toStringAsFixed(2)}km away)",
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white70,
                ),
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
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white70,
          ),
        ),
        Text(
          "${rupiahFormat.format(price.price)}/${price.pricingType}",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white70,
          ),
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
          "${item.averageRating.toStringAsFixed(1)}/5 (${item.ratingCount})",
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white70,
          ),
        ),
      ],
    );
  }
}
