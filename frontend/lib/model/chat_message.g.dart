// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      senderId: (json['senderId'] as num).toInt(),
      receiverId: (json['receiverId'] as num).toInt(),
      message: json['message'] as String,
      imageUrl: json['imageUrl'] as String?,
      isRead: json['isRead'] as bool,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'message': instance.message,
      'imageUrl': instance.imageUrl,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt,
    };
