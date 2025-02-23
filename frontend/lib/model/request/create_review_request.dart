import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_review_request.g.dart';

@JsonSerializable()
class CreateReviewRequest {
  final int rating;
  final String title;
  final String description;

  CreateReviewRequest(
      {required this.rating, required this.title, required this.description});

  factory CreateReviewRequest.fromJsoon(Map<String, dynamic> json) =>
      _$CreateReviewRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateReviewRequestToJson(this);
}
