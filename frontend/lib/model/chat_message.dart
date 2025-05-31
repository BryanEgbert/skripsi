import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

@JsonSerializable()
class ChatMessage {
  int id;
  String type;
  int senderId;
  int receiverId;
  String message;
  String? imageUrl;
  bool isRead;
  String createdAt;

  ChatMessage({
    required this.id,
    required this.type,
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.imageUrl,
    required this.isRead,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  @override
  int get hashCode => senderId.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage && other.senderId == senderId;
  }

  @override
  String toString() {
    return "ChatMessage(id: $id, senderId: $senderId, receiverId: $receiverId)";
  }
}
