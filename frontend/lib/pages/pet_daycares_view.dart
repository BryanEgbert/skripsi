import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/chat_message.dart';
import 'package:frontend/model/pet_daycare.dart';
import 'package:frontend/model/request/pet_daycare_filters.dart';
import 'package:frontend/pages/details/pet_daycare_details_page.dart';
import 'package:frontend/provider/category_provider.dart';
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
  final List<int> _filterPetCategoryIds = [];

  final _minDistanceController = TextEditingController();
  final _maxDistanceController = TextEditingController();

  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();

  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  // StreamSubscription<Position>? _posStreamSubscription;

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
      _filterPetCategoryIds,
      _filters.minimumRating,
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
    _serviceStatusStreamSubscription ??= Geolocator.getServiceStatusStream()
        .listen((ServiceStatus? serviceStatus) {
      if (serviceStatus != null) {
        log("serviceStatus: $serviceStatus");
        setState(() {
          _serviceEnabled =
              serviceStatus == ServiceStatus.enabled ? true : false;
        });
      }
    });

    // _posStreamSubscription ??=
    //     Geolocator.getPositionStream().listen((Position? position) {
    //   if (position != null) {
    //     log("position: ${position.latitude}, ${position.longitude}");
    //     setState(() {
    //       _latitude = position.latitude;
    //       _longitude = position.longitude;
    //     });
    //   }
    // });
    _getLocation().whenComplete(
      () {
        _fetchMoreData();
        _scrollController.addListener(_onScroll);
      },
    );

    _minDistanceController.text = _filters.minDistance.toInt().toString();
    _maxDistanceController.text = _filters.maxDistance.toInt().toString();

    _minPriceController.text = rupiahFormat.format(_filters.minPrice);
    _maxPriceController.text = rupiahFormat.format(_filters.maxPrice);
  }

  @override
  void dispose() {
    _serviceStatusStreamSubscription?.cancel();
    _serviceStatusStreamSubscription = null;

    // _posStreamSubscription?.cancel();
    // _posStreamSubscription = null;

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
    final petCategory = ref.watch(petCategoryProvider);
    final pricingType = ref.watch(pricingTypeProvider);
    final locale = Localizations.localeOf(context).toLanguageTag();

    // _getLocation();

    if (_error != null) {
      handleError(AsyncError(_error!, StackTrace.current), context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.exploreNav,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Constants.primaryTextColor
                : Colors.orange,
          ),
        ),
        actions: [
          Builder(builder: (context) {
            return IconButton(
              icon: Icon(
                Icons.tune_rounded,
                color: Theme.of(context).brightness == Brightness.light
                    ? Constants.primaryTextColor
                    : Colors.orange,
              ),
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
        child: switch (petCategory) {
          AsyncError(:final error) => ErrorText(
              errorText: error.toString(),
              onRefresh: () => ref.refresh(petCategoryProvider.future)),
          AsyncData(:final value) => Column(
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
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Constants.primaryTextColor
                                      : Colors.orange,
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)!.petDaycareFilter,
                                style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Constants.primaryTextColor
                                      : Colors.orange,
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.petVaccination,
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
                                      AppLocalizations.of(context)!
                                          .requiresVaccination,
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
                                      AppLocalizations.of(context)!
                                          .noRequiresVaccination,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    selected:
                                        _filters.mustBeVaccinated == false,
                                    onSelected: (value) {
                                      setState(() {
                                        _filters.mustBeVaccinated =
                                            value ? false : null;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(context)!.pricingModel,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Constants.primaryTextColor,
                                ),
                              ),
                              // Wrap(
                              //   spacing: 4,
                              //   children: [
                              //     FilterChip(
                              //       label: Text(
                              //         "per day",
                              //         style: TextStyle(fontSize: 12),
                              //       ),
                              //       selected: _filters.pricingType == 1,
                              //       onSelected: (value) {
                              //         setState(() {
                              //           _filters.pricingType = value ? 1 : null;
                              //         });
                              //       },
                              //     ),
                              //     FilterChip(
                              //       label: Text(
                              //         "per night",
                              //         style: TextStyle(fontSize: 12),
                              //       ),
                              //       selected: _filters.pricingType == 2,
                              //       onSelected: (value) {
                              //         setState(() {
                              //           _filters.pricingType = value ? 2 : null;
                              //         });
                              //       },
                              //     ),
                              //   ],
                              // ),
                              if (pricingType.hasValue)
                                Wrap(
                                  spacing: 4,
                                  children: pricingType.value!.map((type) {
                                    return FilterChip(
                                      label: Text(
                                        "per ${type.name}",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      selected: _filters.pricingType == type.id,
                                      onSelected: (selected) {
                                        setState(() {
                                          _filters.pricingType =
                                              selected ? type.id : null;
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              const SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(context)!.minimumRating,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Constants.primaryTextColor,
                                ),
                              ),
                              Wrap(
                                spacing: 4,
                                children: [1, 2, 3, 4, 5].map((star) {
                                  return FilterChip(
                                    label: Text(
                                      AppLocalizations.of(context)!
                                          .minStar(star),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    selected: _filters.minimumRating == star,
                                    onSelected: (selected) {
                                      setState(() {
                                        _filters.minimumRating =
                                            selected ? star : 0;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(context)!.petCategoryLabel,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Constants.primaryTextColor,
                                ),
                              ),
                              Wrap(
                                spacing: 4,
                                children: value.map(
                                  (category) {
                                    return FilterChip(
                                      label: Text(
                                        category.name,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      selected: _filterPetCategoryIds
                                          .contains(category.id),
                                      onSelected: (selected) {
                                        if (selected == true) {
                                          setState(() {
                                            _filterPetCategoryIds
                                                .add(category.id);
                                          });
                                        } else {
                                          setState(() {
                                            _filterPetCategoryIds
                                                .remove(category.id);
                                          });
                                        }
                                      },
                                    );
                                  },
                                ).toList(),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(context)!.distanceFilter,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Constants.primaryTextColor,
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)!.distanceInfo,
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
                                  "${NumberFormat.decimalPattern(locale).format(_filters.minDistance.round())} km",
                                  "${NumberFormat.decimalPattern(locale).format(_filters.maxDistance.round())} km",
                                ),
                                values: RangeValues(
                                    _filters.minDistance, _filters.maxDistance),
                                onChanged: _serviceEnabled &&
                                        (_permission ==
                                                LocationPermission.always ||
                                            _permission ==
                                                LocationPermission.whileInUse)
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
                                      enabled: _serviceEnabled &&
                                          (_permission ==
                                                  LocationPermission.always ||
                                              _permission ==
                                                  LocationPermission
                                                      .whileInUse),
                                      controller: _minDistanceController,
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)!
                                            .minDistanceInput,
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
                                        double parsed = int.parse(
                                                _minDistanceController.text)
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
                                          _filters.minDistance = int.parse(
                                                  _minDistanceController.text)
                                              .toDouble();
                                        });
                                      },
                                    ),
                                  ),
                                  Text("-"),
                                  Expanded(
                                    child: TextField(
                                      enabled: _serviceEnabled &&
                                          (_permission ==
                                                  LocationPermission.always ||
                                              _permission ==
                                                  LocationPermission
                                                      .whileInUse),
                                      controller: _maxDistanceController,
                                      decoration: InputDecoration(
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .maxDistanceInput,
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

                                        double parsed = int.parse(
                                                _maxDistanceController.text)
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
                                          _filters.maxDistance = int.parse(
                                                  _maxDistanceController.text)
                                              .toDouble();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(context)!.priceRange,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Constants.primaryTextColor,
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)!.priceRangeInfo,
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
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .minPriceInput,
                                          labelStyle: TextStyle(fontSize: 14),
                                          errorText: _minPriceError),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (value) {
                                        _minPriceError = null;

                                        String digitsOnly = value.replaceAll(
                                            RegExp(r'[^0-9]'), '');
                                        if (digitsOnly.isEmpty) {
                                          digitsOnly = '0';
                                        }

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
                                          _minPriceController.text =
                                              rupiahFormat
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
                                        labelText: AppLocalizations.of(context)!
                                            .maxPriceInput,
                                        labelStyle: TextStyle(fontSize: 14),
                                        errorText: _maxPriceError,
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (value) {
                                        _maxPriceError = null;
                                        String digitsOnly = value.replaceAll(
                                            RegExp(r'[^0-9]'), '');
                                        if (digitsOnly.isEmpty) {
                                          digitsOnly = '0';
                                        }

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
                                          _maxPriceController.text =
                                              rupiahFormat
                                                  .format(_filters.minPrice);
                                        }
                                        if (parsed > 1000000) {
                                          _maxPriceController.text =
                                              rupiahFormat.format(1000000);
                                        }
                                        setState(() {
                                          String digitsOnly =
                                              _maxPriceController.text
                                                  .replaceAll(
                                                      RegExp(r'[^0-9]'), '');
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
                                AppLocalizations.of(context)!.facilities,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Constants.primaryTextColor,
                                ),
                              ),
                              Wrap(
                                spacing: 4,
                                children: [
                                  FilterChip(
                                    selected:
                                        _serviceFeatures.contains("pickup"),
                                    label: Text(
                                      AppLocalizations.of(context)!
                                          .pickupServiceProvided,
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
                                      AppLocalizations.of(context)!
                                          .inHouseFoodProvided,
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
                                    selected:
                                        _serviceFeatures.contains("grooming"),
                                    label: Text(
                                      AppLocalizations.of(context)!
                                          .groomingServiceProvided,
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
                                AppLocalizations.of(context)!.dailyWalks,
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
                                      AppLocalizations.of(context)!
                                          .noWalksProvided,
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
                                      AppLocalizations.of(context)!.oneWalkADay,
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
                                      AppLocalizations.of(context)!
                                          .twoWalksADay,
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
                                      AppLocalizations.of(context)!
                                          .moreThanTwoWalksADay,
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
                                AppLocalizations.of(context)!.dailyPlaytime,
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
                                      AppLocalizations.of(context)!
                                          .noPlaytimeProvided,
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
                                      AppLocalizations.of(context)!
                                          .onePlaySessionADay,
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
                                      AppLocalizations.of(context)!
                                          .twoPlaySessionsADay,
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
                                      AppLocalizations.of(context)!
                                          .moreThanTwoPlaySessionsADay,
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
                        textStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    child: Text(AppLocalizations.of(context)!.applyFilter),
                  )
              ],
            ),
          _ => Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).brightness == Brightness.light
                    ? Constants.primaryTextColor
                    : Colors.orange,
              ),
            )
        },
      ),
      body: (_error != null)
          ? ErrorText(
              errorText: _error.toString(),
              onRefresh: () async {
                _refresh();
              })
          : RefreshIndicator.adaptive(
              onRefresh: () async {
                _refresh();
              },
              child: (_isFetching && _records.isEmpty)
                  ? Center(child: CircularProgressIndicator.adaptive())
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
      bottomSheet: _serviceEnabled == false ||
              _permission == LocationPermission.denied
          ? Container(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.amber[100]
                  : Colors.blueGrey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        spacing: 4,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey[800]
                                    : Colors.white,
                          ),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!
                                  .turnOnLocationMessage,
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.grey[800]
                                    : Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_permission == LocationPermission.denied) {
                          await Geolocator.openLocationSettings();
                        } else {
                          await Geolocator.openAppSettings();
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.turnOn,
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Constants.primaryTextColor
                                  : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  void _refresh() {
    setState(() {
      _records = [];
      _page = 1;
      _hasMoreData = true;
      _fetchMoreData();
    });
  }

  Widget _buildCard(BuildContext context, PetDaycare item) {
    final kmFormatted = (item.distance / 1000).toStringAsFixed(1);

    return Card(
      // elevation: 0,
      // color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PetDaycareDetailsPage(
              item.id,
              latitude: _latitude,
              longitude: _longitude,
            ),
          ));
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              thumbnail(item),
              SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                    if (_latitude != null && _longitude != null)
                      Text(
                        "${item.locality} (${AppLocalizations.of(context)!.kmAway(item.distance / 1000)})",
                        style: TextStyle(
                          fontSize: 10,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white70,
                        ),
                      ),
                    SizedBox(height: 2),
                    avgRatingWidget(item),
                    SizedBox(height: 4),
                    for (var price in item.prices) ...[
                      _priceWidget(price),
                      Divider()
                    ],
                  ],
                ),
              ),
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

  Widget _priceWidget(Price? price) {
    return Row(
      // spacing: 8,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            price!.petCategory.name,
            style: TextStyle(
              fontSize: 10,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Expanded(
          child: Text(
            "${rupiahFormat.format(price.price)}/${price.pricingType.name}",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.end,
          ),
        ),
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
