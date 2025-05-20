import 'package:json_annotation/json_annotation.dart';

part 'send_message.g.dart';

@JsonSerializable()
class SendMessage {
  bool updateRead;
  int receiverId;
  String message;
  String? imageUrl;

  SendMessage({
    this.updateRead = false,
    required this.receiverId,
    required this.message,
    this.imageUrl,
  });

  factory SendMessage.fromJson(Map<String, dynamic> json) =>
      _$SendMessageFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageToJson(this);
}
