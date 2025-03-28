import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/model/lookup.dart';

part 'user.freezed.dart';

part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String name,
    required String email,
    required String imageUrl,
    required Lookup role,
    required List<Lookup?> vetSpecialties,
    required String createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
