import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_review_request.g.dart';

@JsonSerializable()
class CreateReviewRequest {
  final int rating;
  final String description;

  CreateReviewRequest({required this.rating, required this.description});

  factory CreateReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReviewRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateReviewRequestToJson(this);
}
