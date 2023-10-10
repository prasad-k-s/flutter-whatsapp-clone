import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone/common/widgets/error.dart';
import 'package:flutter_whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:flutter_whatsapp_clone/models/message.dart';
import 'package:flutter_whatsapp_clone/widgets/my_message_card.dart';
import 'package:flutter_whatsapp_clone/widgets/sender_message_card.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerWidget {
  const ChatList({required this.recieverId, Key? key}) : super(key: key);
  final String recieverId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<Message>>(
      stream: ref.watch(chatContollerProvider).chatStream(recieverId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return MyErrorWidget(
            error: snapshot.error.toString(),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            if (messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: messageData.text,
                date: DateFormat.Hm().format(
                  messageData.timeSent,
                ),
              );
            }
            return SenderMessageCard(
              message: messageData.text,
              date: DateFormat.Hm().format(
                messageData.timeSent,
              ),
            );
          },
        );
      },
    );
  }
}
