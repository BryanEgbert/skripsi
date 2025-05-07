// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessage _$SendMessageFromJson(Map<String, dynamic> json) => SendMessage(
      receiverId: (json['receiverId'] as num).toInt(),
      message: json['message'] as String,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$SendMessageToJson(SendMessage instance) =>
    <String, dynamic>{
      'receiverId': instance.receiverId,
      'message': instance.message,
      'imageUrl': instance.imageUrl,
    };
