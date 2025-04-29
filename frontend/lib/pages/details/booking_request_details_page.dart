import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/booking_request.dart';
import 'package:frontend/pages/details/pet_details_page.dart';
import 'package:frontend/provider/auth_provider.dart';
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

    handleError(slotState, context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.secondaryBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Booking Details',
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
        actions: appBarActions(ref.read(authProvider.notifier)),
      ),
      body: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Constants.secondaryBackgroundColor,
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  "Booking Period",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                    "${formatDate(widget.bookingReq.startDate)} - ${formatDate(widget.bookingReq.endDate)}"),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "Use Pick-up Service",
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
                if (widget.bookingReq.pickupRequired)
                  Container(
                    padding: EdgeInsets.all(4.0),
                    color: Colors.orangeAccent,
                    child: Column(
                      children: [
                        Text(
                          widget.bookingReq.addressInfo!.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          widget.bookingReq.addressInfo!.address,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // Container(
          //   width: double.infinity,
          //   color: Constants.secondaryBackgroundColor,
          //   padding: EdgeInsets.all(12),
          //   child: Column(
          //     spacing: 8,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         "Pricings",
          //         style: TextStyle(
          //           color: Colors.orange,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 16,
          //         ),
          //       ),
          //       ListView.builder(
          //         physics: NeverScrollableScrollPhysics(),
          //         shrinkWrap: true,
          //         itemCount: widget.transaction.bookedSlot.petCount.length,
          //         itemBuilder: (context, index) {
          //           var item = widget.transaction.bookedSlot.petCount[index];
          //           var pricing = widget.transaction.petDaycare.pricings
          //               .where((e) => e.petCategory.id == item.petCategory.id)
          //               .first;
          //           return Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text("${item.petCategory.name} x ${item.total}"),
          //               Text(
          //                   "Rp. ${pricing.price * item.total}/${pricing.pricingType}"),
          //             ],
          //           );
          //         },
          //       ),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             "Total",
          //             style: TextStyle(fontWeight: FontWeight.bold),
          //           ),
          //           Text(
          //             "Rp. $totalPrice",
          //             style: TextStyle(fontWeight: FontWeight.bold),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Constants.secondaryBackgroundColor,
              padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Booked Pets",
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
                          subtitle:
                              Text("Pet Category: ${item.petCategory.name}"),
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
                  "Accept",
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
                    "Reject",
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
