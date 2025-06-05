import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/components/modals/add_review_modal.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/transaction.dart';
import 'package:frontend/pages/details/pet_details_page.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/slot_provider.dart';
import 'package:frontend/utils/formatter.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/show_confirmation_dialog.dart';
import 'package:intl/intl.dart';

class BookingHistoryDetailsPage extends ConsumerStatefulWidget {
  final int bookedSlotId;
  const BookingHistoryDetailsPage(this.bookedSlotId, {super.key});

  @override
  ConsumerState<BookingHistoryDetailsPage> createState() =>
      _TransactionDetailsPageState();
}

class _TransactionDetailsPageState
    extends ConsumerState<BookingHistoryDetailsPage> {
  final rupiahFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  void _cancelBooking(int bookedSlotId) {
    showCancelBookingConfirmationDialog(context,
        "Are you sure you want to cancel this booking? This action cannot be undone.",
        () {
      ref.read(slotStateProvider.notifier).cancelSlot(bookedSlotId);
      ref.invalidate(getBookedSlotProvider(widget.bookedSlotId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final transaction = ref.watch(getBookedSlotProvider(widget.bookedSlotId));
    final slotState = ref.watch(slotStateProvider);

    handleValue(slotState, this);

    double totalPrice = 0;
    Color statusColor = Colors.black;
    Color chipColor = Colors.transparent;

    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Constants.secondaryBackgroundColor,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.primaryTextColor
                  : Colors.orange,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            AppLocalizations.of(context)!.bookingDetails,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.primaryTextColor
                  : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: appBarActions(),
        ),
        body: switch (transaction) {
          AsyncError(:final error) => ErrorText(
              errorText: error.toString(),
              onRefresh: () => ref
                  .refresh(getBookedSlotProvider(widget.bookedSlotId).future)),
          AsyncData(:final value) => Builder(builder: (context) {
              if (value.status.id == 1) {
                statusColor = Colors.deepOrange;
                chipColor = Color(0xFFFFF080);
              } else if (value.status.id == 2 || value.status.id == 4) {
                statusColor = Colors.green[900]!;
                chipColor = Color(0xFFCAFFC7);
              } else if (value.status.id == 3 || value.status.id == 5) {
                statusColor = Colors.red[900]!;
                chipColor = Color(0XFFFFD7D7);
              }

              totalPrice = _calculatePrice(value, totalPrice);
              return SafeArea(
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.secondaryBackgroundColor
                          : null,
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${AppLocalizations.of(context)!.statusLabel}: ",
                                style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Constants.primaryTextColor
                                        : Colors.orange,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: chipColor,
                                ),
                                child: Text(
                                  value.status.name,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: statusColor,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (value.status.id == 1)
                            TextButton(
                              onPressed: () =>
                                  _cancelBooking(value.bookedSlot.id),
                              child: Text(
                                AppLocalizations.of(context)!.cancelBooking,
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          else if (value.status.id == 4 && !value.isReviewed)
                            TextButton(
                              onPressed: () async {
                                await showModalBottomSheet(
                                  context: context,
                                  builder: (context) =>
                                      AddReviewModal(value.petDaycare.id),
                                );

                                setState(() {
                                  ref.invalidate(getBookedSlotProvider(
                                      widget.bookedSlotId));
                                });
                              },
                              child: Text(
                                AppLocalizations.of(context)!.giveReview,
                                style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Constants.primaryTextColor
                                      : Colors.orange,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.secondaryBackgroundColor
                          : null,
                      padding: EdgeInsets.all(12),
                      child: Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            value.petDaycare.name,
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Constants.primaryTextColor
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            value.petDaycare.address,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white70,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context)!.reservationDates,
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Constants.primaryTextColor
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "${formatDateStr(value.startDate, context)} - ${formatDateStr(value.endDate, context)}",
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white70,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            spacing: 4,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.usePickupService,
                                style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Constants.primaryTextColor
                                      : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (value.bookedSlot.pickupRequired)
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              else
                                Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                )
                            ],
                          ),
                          if (value.bookedSlot.pickupRequired)
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? const Color.fromARGB(255, 255, 226, 193)
                                    : Colors.black87,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    value.addressInfo!.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    value.addressInfo!.address,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.secondaryBackgroundColor
                          : null,
                      padding: EdgeInsets.all(12),
                      child: Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.pricings,
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Constants.primaryTextColor
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: value.bookedSlot.petCount.length,
                            itemBuilder: (context, index) {
                              var item = value.bookedSlot.petCount[index];
                              var pricing = value.petDaycare.pricings
                                  .where((e) =>
                                      e.petCategory.id == item.petCategory.id)
                                  .first;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${item.petCategory.name} x ${item.total}",
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    "${rupiahFormat.format(pricing.price * item.total)}/${pricing.pricingType.name}",
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white70,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.total,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white70,
                                ),
                              ),
                              Text(
                                rupiahFormat.format(totalPrice),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Constants.secondaryBackgroundColor
                            : null,
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.reservedPets,
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Constants.primaryTextColor
                                    : Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SingleChildScrollView(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: value.bookedSlot.bookedPet.length,
                                itemBuilder: (context, index) {
                                  var item = value.bookedSlot.bookedPet[index];
                                  return ListTile(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => PetDetailsPage(
                                          petId: item.id,
                                          isOwner: true,
                                        ),
                                      ));
                                    },
                                    leading: DefaultCircleAvatar(
                                        imageUrl: item.imageUrl ?? ""),
                                    title: Text(item.name),
                                    subtitle: Text(AppLocalizations.of(context)!
                                        .petCategory(item.petCategory.name)),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          _ => Center(child: CircularProgressIndicator.adaptive()),
        });
  }

  double _calculatePrice(Transaction value, double totalPrice) {
    for (var pet in value.bookedSlot.petCount) {
      var pricing = value.petDaycare.pricings
          .where((e) => e.petCategory.id == pet.petCategory.id)
          .first;
      DateTime startDate = DateTime.parse(value.startDate);
      DateTime endDate = DateTime.parse(value.endDate);

      Duration difference = endDate.difference(startDate);

      totalPrice += pricing.price *
          pet.total *
          (difference.inDays + (pricing.pricingType == "day" ? 1 : 0));
    }
    return totalPrice;
  }
}
