import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/components/image_slider.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/pet_daycare.dart';
import 'package:frontend/pages/book_slots_page.dart';
import 'package:frontend/pages/chat_page.dart';
import 'package:frontend/pages/edit/edit_pet_daycare_page.dart';
import 'package:frontend/pages/ratings_page.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/utils/formatter.dart';
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
              icon: const Icon(Icons.arrow_back_ios, color: Colors.orange),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Pet Daycare',
                style: TextStyle(color: Colors.orange)),
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
                    icon:
                        const Icon(Icons.arrow_back_ios, color: Colors.orange),
                    onPressed: () => Navigator.pop(context),
                  )
                : null,
            title: const Text(
              'Pet Daycare',
              style: TextStyle(color: Colors.orange),
            ),
            actions: appBarActions(),
          ),
          floatingActionButton: (widget.petDaycareId == 0)
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditPetDaycarePage(value.id),
                      ),
                    );
                  },
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.edit),
                )
              : null,
          body: _buildBody(value),
        );

      default:
        return Center(
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        );
    }
  }

  Widget _buildBody(PetDaycareDetails value) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  if (widget.latitude != null &&
                      widget.longitude != null &&
                      widget.petDaycareId != 0) ...[
                    Text(
                      "${(value.distance.toDouble() / 1000).toStringAsFixed(2)}km away",
                      style: TextStyle(fontSize: 12),
                      maxLines: 2,
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
                        "${value.averageRating.toStringAsFixed(1)}/5 (${value.ratingCount})",
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "|",
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${formatNumber(value.bookedNum)} ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      Text(
                        "slots booked",
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
                        color: Colors.orange,
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
                  const Text(
                    "Pricing",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (var price in value.pricings)
                    if (price.petCategory.sizeCategory.maxWeight != null)
                      Text(
                        "${price.petCategory.name} (${price.petCategory.sizeCategory.minWeight}-${price.petCategory.sizeCategory.maxWeight}kg) - Rp. ${price.price}/${price.pricingType}",
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white70,
                        ),
                      )
                    else
                      Text(
                        "${price.petCategory.name} (${price.petCategory.sizeCategory.minWeight}kg+) - Rp. ${price.price}/${price.pricingType}",
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white70,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Services",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    value.mustBeVaccinated
                        ? Icon(Icons.check, color: Colors.green)
                        : Icon(Icons.close, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      "Pet Vaccination Required",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white70,
                      ),
                    ),
                  ]),
                  Row(children: [
                    value.hasPickupService
                        ? Icon(Icons.check, color: Colors.green)
                        : Icon(Icons.close, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      "Pick-Up Service",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white70,
                      ),
                    ),
                  ]),
                  Row(children: [
                    value.groomingAvailable
                        ? Icon(Icons.check, color: Colors.green)
                        : Icon(Icons.close, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      "Grooming Service",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white70,
                      ),
                    ),
                  ]),
                  Row(children: [
                    value.foodProvided
                        ? Icon(Icons.check, color: Colors.green)
                        : Icon(Icons.close, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      "In-House Food Provided",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white70,
                      ),
                    ),
                  ]),
                  // if (value.foodProvided)
                  //   const Padding(
                  //     padding: EdgeInsets.only(left: 32.0),
                  //     child: Text("Brand: Pedigree",
                  //         style: TextStyle(color: Colors.grey)),
                  //   ),
                  const SizedBox(height: 16),
                  const Text(
                    "Number of Walks",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    value.dailyWalks.name,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Number of Playtime",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    value.dailyPlaytime.name,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white70,
                    ),
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
                    const Text(
                      "View Ratings >",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.petDaycareId != 0) ...[
              const SizedBox(height: 16),
              Container(
                margin: EdgeInsets.only(right: 12),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BookSlotsPage(value),
                    ));
                  },
                  child: Text("Book A Slot"),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
