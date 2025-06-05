import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/error_text.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/model/request/create_review_request.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/provider/list_data_provider.dart';
import 'package:frontend/provider/review_provider.dart';
import 'package:frontend/services/localization_service.dart';

class AddReviewModal extends ConsumerStatefulWidget {
  final int petDaycareId;
  const AddReviewModal(this.petDaycareId, {super.key});

  @override
  ConsumerState<AddReviewModal> createState() => _AddReviewModalState();
}

class _AddReviewModalState extends ConsumerState<AddReviewModal> {
  final _descriptionController = TextEditingController();
  double _rating = 0;

  String? _descriptionInputError;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(getMyUserProvider);
    final reviewState = ref.watch(reviewStateProvider);

    // handleValue(
    //     reviewState, this, ref.read(reviewStateProvider.notifier).reset);

    if (reviewState.hasError &&
        (reviewState.valueOrNull == null || reviewState.valueOrNull == 0) &&
        !reviewState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        var snackbar = SnackBar(
          key: Key("error-message"),
          content: Text(
            reviewState.error.toString(),
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red[800],
        );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);

        if (reviewState.error.toString() == LocalizationService().jwtExpired ||
            reviewState.error.toString() == LocalizationService().userDeleted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => WelcomeWidget(),
            ),
            (route) => false,
          );
        }

        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        ref.read(reviewStateProvider.notifier).reset();
      });
    }

    if (reviewState.hasValue && !reviewState.isLoading) {
      if (reviewState.value != null) {
        if (reviewState.value is int) {
          if (reviewState.value! >= 200 && reviewState.value! <= 400) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

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

              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }

              ref.read(reviewStateProvider.notifier).reset();
            });
          }
        }
      }
    }

    return switch (user) {
      AsyncError(:final error) => ErrorText(
          errorText: error.toString(),
          onRefresh: () => ref.refresh(getMyUserProvider.future),
        ),
      AsyncData() => Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 24, 12, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              StarRating(
                size: 50,
                allowHalfRating: false,
                rating: _rating,
                color: Colors.yellow[700],
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
                  errorText: _descriptionInputError,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  if (reviewState.isLoading) return;
                  if (_descriptionController.text.isEmpty) {
                    setState(() {
                      _descriptionInputError = "description cannot be empty";
                    });
                    return;
                  }
                  ref.read(reviewStateProvider.notifier).addReview(
                      widget.petDaycareId,
                      CreateReviewRequest(
                        rating: _rating.toInt(),
                        description: _descriptionController.text,
                      ));
                },
                child: (!reviewState.isLoading)
                    ? Text(
                        "Add Review",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    : CircularProgressIndicator(color: Colors.white),
              ),
            ],
          ),
        ),
      _ => Center(
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        ),
    };
  }
}
