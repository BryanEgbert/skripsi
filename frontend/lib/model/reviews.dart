import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/model/user.dart';

part 'reviews.freezed.dart';
part 'reviews.g.dart';

@freezed
class Reviews with _$Reviews {
  const factory Reviews({
    required int id,
    required int rating,
    required String title,
    required String description,
    required User user,
    required String createdAt,
  }) = _Reviews;

  factory Reviews.fromJson(Map<String, dynamic> json) =>
      _$ReviewsFromJson(json);
}
