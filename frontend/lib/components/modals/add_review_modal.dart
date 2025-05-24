import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/model/request/create_review_request.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/review_provider.dart';
import 'package:frontend/utils/handle_error.dart';

class AddReviewModal extends ConsumerStatefulWidget {
  final int petDaycareId;
  const AddReviewModal(this.petDaycareId, {super.key});

  @override
  ConsumerState<AddReviewModal> createState() => _AddReviewModalState();
}

class _AddReviewModalState extends ConsumerState<AddReviewModal> {
  final _descriptionController = TextEditingController();
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(getMyUserProvider);
    final reviewState = ref.watch(reviewStateProvider);

    handleValue(reviewState, context);

    return switch (user) {
      AsyncError(:final error) => ErrorText(
          errorText: error.toString(),
          onRefresh: () => ref.refresh(getMyUserProvider.future),
        ),
      AsyncData(:final value) => Column(
          children: [
            StarRating(
              allowHalfRating: false,
              onRatingChanged: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            TextField(
              controller: _descriptionController,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                labelText: "Description",
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  ref.read(reviewStateProvider.notifier).addReview(
                      widget.petDaycareId,
                      CreateReviewRequest(
                        rating: _rating.toInt(),
                        title: value.name,
                        description: _descriptionController.text,
                      ));
                },
                child: Text(
                  "Submit",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ],
        ),
      _ => Center(
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        ),
    };
  }
}
