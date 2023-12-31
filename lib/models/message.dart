// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_whatsapp_clone/common/enum/message_enum.dart';

class Message {
  final String senderId;
  final String recieverId;
  final String text;
  final String messageId;
  final MessageEnum type;
  final bool isSeen;
  final DateTime timeSent;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedmessageType;
  Message({
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedmessageType,
    required this.senderId,
    required this.recieverId,
    required this.text,
    required this.messageId,
    required this.type,
    required this.isSeen,
    required this.timeSent,
  });

  Message copyWith({
    String? senderId,
    String? recieverId,
    String? text,
    String? messageId,
    MessageEnum? type,
    bool? isSeen,
    DateTime? timeSent,
    String? repliedMessage,
    String? repliedTo,
    MessageEnum? repliedmessageType,
  }) {
    return Message(
      senderId: senderId ?? this.senderId,
      recieverId: recieverId ?? this.recieverId,
      text: text ?? this.text,
      messageId: messageId ?? this.messageId,
      type: type ?? this.type,
      isSeen: isSeen ?? this.isSeen,
      timeSent: timeSent ?? this.timeSent,
      repliedMessage: repliedMessage ?? this.repliedMessage,
      repliedTo: repliedTo ?? this.repliedTo,
      repliedmessageType: repliedmessageType ?? this.repliedmessageType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'recieverId': recieverId,
      'text': text,
      'messageId': messageId,
      'type': type.type,
      'isSeen': isSeen,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'repliedmessageType': repliedmessageType.type,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      recieverId: map['recieverId'] as String,
      text: map['text'] as String,
      messageId: map['messageId'] as String,
      type: (map['type'] as String).toEnum(),
      isSeen: map['isSeen'] as bool,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      repliedMessage: map['repliedMessage'] as String,
      repliedTo: map['repliedTo'] as String,
      repliedmessageType: (map['repliedmessageType'] as String).toEnum(),
    );
  }
}
