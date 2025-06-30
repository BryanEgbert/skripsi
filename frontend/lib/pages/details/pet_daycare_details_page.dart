import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/components/image_slider.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/pet_daycare.dart';
import 'package:frontend/pages/book_slots_page.dart';
import 'package:frontend/pages/chat_page.dart';
import 'package:frontend/pages/edit/edit_pet_daycare_page.dart';
import 'package:frontend/pages/ratings_page.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/utils/formatter.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

class PetDaycareDetailsPage extends ConsumerStatefulWidget {
  final int petDaycareId;
  final double? latitude;
  final double? longitude;

  const PetDaycareDetailsPage(this.petDaycareId,
      {super.key, this.latitude, this.longitude});

  const PetDaycareDetailsPage.my({Key? key}) : this(0, key: key);

  @override
  ConsumerState<PetDaycareDetailsPage> createState() =>
      _PetDaycareDetailsPageState();
}

class _PetDaycareDetailsPageState extends ConsumerState<PetDaycareDetailsPage> {
  final rupiahFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    AsyncValue<PetDaycareDetails> daycare;

    if (widget.petDaycareId != 0) {
      daycare = ref.watch(getPetDaycareByIdProvider(
          widget.petDaycareId, widget.latitude, widget.longitude));
    } else {
      daycare = ref.watch(getMyPetDaycareProvider);
    }

    switch (daycare) {
      case AsyncError(:final error):
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).brightness == Brightness.light
                    ? Constants.primaryTextColor
                    : Colors.orange,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(AppLocalizations.of(context)!.petDaycareBoarding,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Constants.primaryTextColor
                      : Colors.orange,
                )),
            actions: appBarActions(),
          ),
          floatingActionButton: widget.petDaycareId != 0
              ? FloatingActionButton.large(
                  onPressed: () {},
                  backgroundColor: Colors.orange,
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                )
              : null,
          body: ErrorText(
              errorText: error.toString(),
              onRefresh: () => (widget.petDaycareId != 0)
                  ? ref.refresh(getPetDaycareByIdProvider(widget.petDaycareId,
                          widget.latitude, widget.longitude)
                      .future)
                  : ref.refresh(getMyPetDaycareProvider.future)),
        );
      case AsyncData(:final value):
        return Scaffold(
          appBar: AppBar(
            leading: (widget.petDaycareId != 0)
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.primaryTextColor
                          : Colors.orange,
                    ),
                    onPressed: () => Navigator.pop(context),
                  )
                : null,
            title: Text(
              AppLocalizations.of(context)!.petDaycareBoarding,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Constants.primaryTextColor
                    : Colors.orange,
              ),
            ),
            actions: appBarActions(),
          ),
          floatingActionButton: (widget.petDaycareId == 0)
              ? FloatingActionButton(
                  onPressed: () async {
                    bool? success = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditPetDaycarePage(value.id),
                      ),
                    );

                    if (success == null) return;
                    if (success) {
                      if (!mounted) return;
                      var snackbar = SnackBar(
                        key: Key("success-message"),
                        content: Text(
                          AppLocalizations.of(context)!.operationSuccess,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.green[800],
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                  },
                  foregroundColor: Colors.white,
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.light
                          ? Constants.primaryTextColor
                          : Colors.orange,
                  child: Icon(Icons.edit),
                )
              : null,
          body: _buildBody(value),
        );

      default:
        return Scaffold(
          body: Center(child: CircularProgressIndicator.adaptive()),
        );
    }
  }

  Widget _buildBody(PetDaycareDetails value) {
    Locale locale = Localizations.localeOf(context);
    NumberFormat numberFormatter =
        NumberFormat.compact(locale: locale.toLanguageTag());
    log("pricings: ${value.pricings.length}");

    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImageSlider(
              images: value.thumbnailUrls,
            ),
            Container(
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.secondaryBackgroundColor
                  : null,
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.primaryTextColor
                          : Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.latitude != null &&
                      widget.longitude != null &&
                      widget.petDaycareId != 0) ...[
                    Text(
                      AppLocalizations.of(context)!
                          .kmAway(value.distance / 1000),
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 4),
                  ],
                  Text(
                    value.address,
                    style: TextStyle(fontSize: 12),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 16),
                      SizedBox(width: 4),
                      Text(
                        "${numberFormatter.format(value.averageRating)}/5 (${formatNumber(value.ratingCount, locale.toLanguageTag())})",
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "|",
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${formatNumber(value.bookedNum, locale.toLanguageTag())} ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      Text(
                        AppLocalizations.of(context)!.slotsBooked,
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  if (widget.petDaycareId != 0)
                    ListTile(
                      contentPadding: EdgeInsets.all(0),
                      leading: DefaultCircleAvatar(
                        imageUrl: value.owner.imageUrl,
                        iconSize: 16,
                        circleAvatarRadius: 16,
                      ),
                      title: Text(
                        value.owner.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Constants.primaryTextColor
                                  : Colors.orange,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chat_rounded,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Constants.primaryTextColor
                            : Colors.orange,
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ChatPage(userId: value.owner.id),
                        ));
                      },
                    ),
                  if (value.description != "")
                    ReadMoreText(
                      value.description,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white70,
                      ),
                      moreStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                      lessStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.secondaryBackgroundColor
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalizations.of(context)!.operationalHour,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.primaryTextColor
                          : Colors.orange,
                    ),
                  ),
                  Text("${value.openingHour} - ${value.closingHour}"),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.secondaryBackgroundColor
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalizations.of(context)!.pricings,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.primaryTextColor
                          : Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (var price in value.pricings)
                    if (price.petCategory.sizeCategory.maxWeight != null)
                      Text(
                        "${price.petCategory.name} (${numberFormatter.format(price.petCategory.sizeCategory.minWeight)}-${numberFormatter.format(price.petCategory.sizeCategory.maxWeight)}kg) - ${rupiahFormat.format(price.price)}/${price.pricingType.name}",
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white70,
                        ),
                      )
                    else
                      Text(
                        "${price.petCategory.name} (${numberFormatter.format(price.petCategory.sizeCategory.minWeight)}kg+) - Rp. ${rupiahFormat.format(price.price)}/${price.pricingType.name}",
                      ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.secondaryBackgroundColor
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.requirements,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.primaryTextColor
                          : Colors.orange,
                    ),
                  ),
                  ListTile(
                    leading: value.mustBeVaccinated
                        ? Icon(
                            Icons.shield,
                            color: Colors.orange,
                          )
                        : Icon(
                            Icons.shield_outlined,
                            color: Colors.blueGrey,
                          ),
                    title: value.mustBeVaccinated
                        ? Text(AppLocalizations.of(context)!
                            .petVaccinationRequired)
                        : Text(AppLocalizations.of(context)!
                            .petVaccinationNotRequired),
                    titleTextStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.primaryTextColor
                          : Colors.orange,
                      fontSize: 18,
                    ),
                    subtitle: value.mustBeVaccinated
                        ? Text(AppLocalizations.of(context)!
                            .petVaccinationIsRequired)
                        : Text(AppLocalizations.of(context)!
                            .petVaccinationIsNotRequired),
                  ),
                  Text(
                    AppLocalizations.of(context)!.additionalServices,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.primaryTextColor
                          : Colors.orange,
                    ),
                  ),
                  ListTile(
                    leading: value.groomingAvailable
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.cancel, color: Colors.grey),
                    title: Text(AppLocalizations.of(context)!.groomingService),
                    titleTextStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.primaryTextColor
                          : Colors.orange,
                      fontSize: 18,
                    ),
                    subtitle: value.groomingAvailable
                        ? Text(AppLocalizations.of(context)!.serviceProvided)
                        : Text(
                            AppLocalizations.of(context)!.serviceNotProvided,
                            style: TextStyle(color: Colors.grey),
                          ),
                  ),
                  ListTile(
                    leading: value.hasPickupService
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.cancel,
                            color: Colors.grey), // More neutral
                    title: Text(AppLocalizations.of(context)!.pickupService),
                    titleTextStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.primaryTextColor
                          : Colors.orange,
                      fontSize: 18,
                    ),
                    subtitle: value.hasPickupService
                        ? Text(AppLocalizations.of(context)!.serviceProvided)
                        : Text(AppLocalizations.of(context)!.serviceNotProvided,
                            style: TextStyle(color: Colors.grey)),
                  ),
                  ListTile(
                    leading: value.foodProvided
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.cancel, color: Colors.grey),
                    title: Text(AppLocalizations.of(context)!
                        .inHouseFoodProvidedDetails),
                    titleTextStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.primaryTextColor
                          : Colors.orange,
                      fontSize: 18,
                    ),
                    subtitle: value.foodProvided
                        ? Text(AppLocalizations.of(context)!.serviceProvided)
                        : Text(
                            AppLocalizations.of(context)!.serviceNotProvided,
                            style: TextStyle(color: Colors.grey),
                          ),
                  ),
                  // if (value.foodProvided)
                  //   const Padding(
                  //     padding: EdgeInsets.only(left: 32.0),
                  //     child: Text("Brand: Pedigree",
                  //         style: TextStyle(color: Colors.grey)),
                  //   ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.numberOfWalks),
                    titleTextStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.primaryTextColor
                          : Colors.orange,
                      fontSize: 18,
                    ),
                    subtitle: Text(value.dailyWalks.name),
                  ),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.numberOfPlaytime),
                    titleTextStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.primaryTextColor
                          : Colors.orange,
                      fontSize: 18,
                    ),
                    subtitle: Text(value.dailyPlaytime.name),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RatingsPage(
                          value.id,
                          ratingsAvg: value.averageRating,
                          ratingsCount: value.ratingCount,
                        )));
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                color: Theme.of(context).brightness == Brightness.light
                    ? Constants.secondaryBackgroundColor
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${AppLocalizations.of(context)!.viewReviews} >",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Constants.primaryTextColor
                            : Colors.orange,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor:
                            Theme.of(context).brightness == Brightness.light
                                ? Constants.primaryTextColor
                                : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.petDaycareId != 0) ...[
              const SizedBox(height: 16),
              Container(
                margin: EdgeInsets.fromLTRB(8, 0, 8, 12),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BookSlotsPage(value),
                    ));
                  },
                  child: Text(AppLocalizations.of(context)!.bookSlot),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
