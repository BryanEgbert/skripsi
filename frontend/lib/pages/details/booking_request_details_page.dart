import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/booking_request.dart';
import 'package:frontend/pages/details/pet_details_page.dart';
import 'package:frontend/provider/slot_provider.dart';
import 'package:frontend/utils/formatter.dart';
import 'package:frontend/utils/handle_error.dart';

class BookingRequestDetailsPage extends ConsumerStatefulWidget {
  final BookingRequest bookingReq;
  const BookingRequestDetailsPage(this.bookingReq, {super.key});

  @override
  ConsumerState<BookingRequestDetailsPage> createState() =>
      _BookingRequestDetailsPageState();
}

class _BookingRequestDetailsPageState
    extends ConsumerState<BookingRequestDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final slotState = ref.watch(slotStateProvider);

    handleValue(slotState, this);

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
        title: Text(
          AppLocalizations.of(context)!.bookingDetails,
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
        actions: appBarActions(),
      ),
      body: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Theme.of(context).brightness == Brightness.light
                ? Constants.secondaryBackgroundColor
                : null,
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.reservationDates,
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "${formatDateStr(widget.bookingReq.startDate, context)} - ${formatDateStr(widget.bookingReq.endDate, context)}",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white70,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  spacing: 8,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.usePickupService,
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (widget.bookingReq.pickupRequired)
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
                if (widget.bookingReq.pickupRequired) const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Theme.of(context).brightness == Brightness.light
                        ? Color.fromARGB(255, 255, 227, 193)
                        : Colors.black87,
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.bookingReq.addressInfo!.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white70,
                        ),
                      ),
                      Text(
                        widget.bookingReq.addressInfo!.address,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              Theme.of(context).brightness == Brightness.light
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
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.bookingReq.bookedPet.length,
                      itemBuilder: (context, index) {
                        var item = widget.bookingReq.bookedPet[index];
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PetDetailsPage(
                                  petId: item.id, isOwner: false),
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
          Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(slotStateProvider.notifier)
                      .acceptSlot(widget.bookingReq.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                ),
                child: Text(
                  AppLocalizations.of(context)!.accept,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: ElevatedButton(
                  onPressed: () {
                    ref
                        .read(slotStateProvider.notifier)
                        .cancelSlot(widget.bookingReq.id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[800],
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.reject,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
