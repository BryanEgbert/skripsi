import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/app_bar_actions.dart';
import 'package:frontend/components/default_circle_avatar.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/details/pet_details_page.dart';
import 'package:frontend/provider/auth_provider.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/slot_provider.dart';
import 'package:frontend/utils/formatter.dart';
import 'package:frontend/utils/handle_error.dart';
import 'package:frontend/utils/show_confirmation_dialog.dart';

class TransactionDetailsPage extends ConsumerStatefulWidget {
  final int transactionId;
  const TransactionDetailsPage(this.transactionId, {super.key});

  @override
  ConsumerState<TransactionDetailsPage> createState() =>
      _TransactionDetailsPageState();
}

class _TransactionDetailsPageState
    extends ConsumerState<TransactionDetailsPage> {
  void _cancelBooking(int bookedSlotId) {
    showCancelBookingConfirmationDialog(context,
        "Are you sure you want to cancel this booking? This action cannot be undone.",
        () {
      ref.read(slotStateProvider.notifier).cancelSlot(bookedSlotId);
      ref.invalidate(getTransactionProvider(widget.transactionId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final transaction = ref.watch(getTransactionProvider(widget.transactionId));
    final slotState = ref.watch(slotStateProvider);

    handleValue(slotState, context);

    double totalPrice = 0;
    Color statusColor = Colors.black;
    Color chipColor = Colors.transparent;

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
          actions: appBarActions(),
        ),
        body: switch (transaction) {
          AsyncError(:final error) => ErrorText(
              errorText: error.toString(),
              onRefresh: () => ref.refresh(
                  getTransactionProvider(widget.transactionId).future)),
          AsyncData(:final value) => Builder(builder: (context) {
              if (value.status.id == 1) {
                statusColor = Colors.deepOrange;
                chipColor = Color(0xFFFFF080);
              } else if (value.status.id == 2 || value.status.id == 4) {
                statusColor = Colors.green;
                chipColor = Color(0xFFCAFFC7);
              } else if (value.status.id == 3 || value.status.id == 5) {
                statusColor = Colors.red;
                chipColor = Color(0XFFFFD7D7);
              }

              for (var pet in value.bookedSlot.petCount) {
                var pricing = value.petDaycare.pricings
                    .where((e) => e.petCategory.id == pet.petCategory.id)
                    .first;
                totalPrice += pricing.price * pet.total;
              }
              return Column(
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
                  ),
                  Container(
                    color: Constants.secondaryBackgroundColor,
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value.petDaycare.name,
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          value.petDaycare.address,
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
                            "${formatDateStr(value.startDate)} - ${formatDateStr(value.endDate)}"),
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
                            padding: EdgeInsets.all(4.0),
                            color: Colors.orangeAccent,
                            child: Column(
                              children: [
                                Text(
                                  value.addressInfo!.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  value.addressInfo!.address,
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
                          itemCount: value.bookedSlot.petCount.length,
                          itemBuilder: (context, index) {
                            var item = value.bookedSlot.petCount[index];
                            var pricing = value.petDaycare.pricings
                                .where((e) =>
                                    e.petCategory.id == item.petCategory.id)
                                .first;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "${item.petCategory.name} x ${item.total}"),
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
                              itemCount: value.bookedSlot.bookedPet.length,
                              itemBuilder: (context, index) {
                                var item = value.bookedSlot.bookedPet[index];
                                return ListTile(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => PetDetailsPage(
                                          petId: item.id, isOwner: true),
                                    ));
                                  },
                                  leading: DefaultCircleAvatar(
                                      imageUrl: item.imageUrl ?? ""),
                                  title: Text(item.name),
                                  subtitle: Text(
                                      "Pet Category: ${item.petCategory.name}"),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (value.status.id == 1) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton(
                            onPressed: () =>
                                _cancelBooking(value.bookedSlot.id),
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
              );
            }),
          _ => Center(child: CircularProgressIndicator.adaptive()),
        });
  }
}
