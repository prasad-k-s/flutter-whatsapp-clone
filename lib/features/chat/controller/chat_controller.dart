// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone/common/enum/message_enum.dart';
import 'package:flutter_whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:flutter_whatsapp_clone/features/chat/repository/chat_repository.dart';
import 'package:flutter_whatsapp_clone/models/chat_contact.dart';
import 'package:flutter_whatsapp_clone/models/message.dart';
import 'package:flutter_whatsapp_clone/models/user_model.dart';

final chatContollerProvider = Provider(
  (ref) {
    final chatRepository = ref.watch(chatRepositiryProvider);
    return ChatController(chatRepository: chatRepository, ref: ref);
  },
);

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> chatStream(String recieverId) {
    return chatRepository.getChatMessages(recieverId);
  }

  void sendTextMessage(BuildContext context, String text, String recieverUserId) {
    ref.read(userDataAuthProvider).whenData((UserModel? senderUser) {
      chatRepository.sendTextMessage(
        context: context,
        text: text,
        recieverUserId: recieverUserId,
        senderUser: senderUser!,
      );
    });
  }

  Future<void> sendFileMessage(
    BuildContext context,
    File file,
    String recieverUserId,
    MessageEnum messageEnum,
  ) async {
    ref.read(userDataAuthProvider).whenData((UserModel? senderUserData) async {
      await chatRepository.sendFileMessage(
        context: context,
        recieverUserId: recieverUserId,
        file: file,
        senderUserData: senderUserData!,
        ref: ref,
        messageEnum: messageEnum,
      );
    });
  }
}