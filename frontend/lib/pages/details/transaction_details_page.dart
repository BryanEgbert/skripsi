import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/model/transaction.dart';
import 'package:frontend/pages/details/pet_details_page.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/slot_provider.dart';
import 'package:frontend/utils/formatter.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/show_confirmation_dialog.dart';

class TransactionDetailsPage extends ConsumerStatefulWidget {
  final Transaction transaction;
  const TransactionDetailsPage(this.transaction, {super.key});

  @override
  ConsumerState<TransactionDetailsPage> createState() =>
      _TransactionDetailsPageState();
}

class _TransactionDetailsPageState
    extends ConsumerState<TransactionDetailsPage> {
  void _cancelBooking() {
    showCancelBookingConfirmationDialog(
      context,
      "Are you sure you want to cancel this booking? This action cannot be undone.",
      () => ref
          .read(slotStateProvider.notifier)
          .cancelSlot(widget.transaction.bookedSlot.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final slotState = ref.watch(slotStateProvider);

    handleError(slotState, context);

    double totalPrice = 0;
    Color statusColor = Colors.black;
    Color chipColor = Colors.transparent;

    if (widget.transaction.status.id == 1) {
      statusColor = Colors.deepOrange;
      chipColor = Color(0xFFFFF080);
    } else if (widget.transaction.status.id == 2 ||
        widget.transaction.status.id == 4) {
      statusColor = Colors.green;
      chipColor = Color(0xFFCAFFC7);
    } else if (widget.transaction.status.id == 3 ||
        widget.transaction.status.id == 5) {
      statusColor = Colors.red;
      chipColor = Color(0XFFFFD7D7);
    }

    for (var pet in widget.transaction.bookedSlot.petCount) {
      var pricing = widget.transaction.petDaycare.pricings
          .where((e) => e.petCategory.id == pet.petCategory.id)
          .first;
      totalPrice += pricing.price * pet.total;
    }

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
            child: Row(
              children: [
                Text("Status: "),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: chipColor,
                  ),
                  child: Text(
                    widget.transaction.status.name,
                    style: TextStyle(
                      fontSize: 10,
                      color: statusColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Constants.secondaryBackgroundColor,
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.transaction.petDaycare.name,
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.transaction.petDaycare.address,
                  style: TextStyle(fontSize: 12),
                ),
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
                    "${formatDate(widget.transaction.startDate)} - ${formatDate(widget.transaction.endDate)}"),
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
                    if (widget.transaction.bookedSlot.pickupRequired)
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
                if (widget.transaction.bookedSlot.pickupRequired)
                  Container(
                    padding: EdgeInsets.all(4.0),
                    color: Colors.orangeAccent,
                    child: Column(
                      children: [
                        Text(
                          widget.transaction.addressInfo!.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          widget.transaction.addressInfo!.address,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: Constants.secondaryBackgroundColor,
            padding: EdgeInsets.all(12),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pricings",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.transaction.bookedSlot.petCount.length,
                  itemBuilder: (context, index) {
                    var item = widget.transaction.bookedSlot.petCount[index];
                    var pricing = widget.transaction.petDaycare.pricings
                        .where((e) => e.petCategory.id == item.petCategory.id)
                        .first;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${item.petCategory.name} x ${item.total}"),
                        Text(
                            "Rp. ${pricing.price * item.total}/${pricing.pricingType}"),
                      ],
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Rp. $totalPrice",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                      itemCount: widget.transaction.bookedSlot.bookedPet.length,
                      itemBuilder: (context, index) {
                        var item =
                            widget.transaction.bookedSlot.bookedPet[index];
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  PetDetailsPage(petId: item.id, isOwner: true),
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
          if (widget.transaction.status.id == 1) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    // TODO: test cancel booking
                    onPressed: _cancelBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text(
                      "Cancel Booking",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ]
        ],
      ),
    );
  }
}
