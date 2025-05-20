import 'package:json_annotation/json_annotation.dart';

part 'upload_image_response.g.dart';

@JsonSerializable()
class UploadImageResponse {
  final String imageUrl;

  UploadImageResponse({
    required this.imageUrl,
  });

  factory UploadImageResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadImageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UploadImageResponseToJson(this);
}
