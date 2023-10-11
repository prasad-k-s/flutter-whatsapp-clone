import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone/common/enum/message_enum.dart';
import 'package:flutter_whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:flutter_whatsapp_clone/common/widgets/error.dart';
import 'package:flutter_whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:flutter_whatsapp_clone/models/message.dart';
import 'package:flutter_whatsapp_clone/widgets/my_message_card.dart';
import 'package:flutter_whatsapp_clone/widgets/sender_message_card.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({required this.recieverId, Key? key}) : super(key: key);
  final String recieverId;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onMessageSwipe({required String message, required bool isMe, required MessageEnum messageEnum}) {
    ref.read(messageReplyProvider.notifier).update(
          (state) => MessageReply(
            message: message,
            isMe: isMe,
            messageEnum: messageEnum,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: ref.watch(chatContollerProvider).chatStream(widget.recieverId),
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

        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: scrollController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            if (messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: messageData.text,
                date: DateFormat.Hm().format(
                  messageData.timeSent,
                ),
                type: messageData.type,
                userName: messageData.repliedTo,
                repliedText: messageData.repliedMessage,
                repliedMessageType: messageData.repliedmessageType,
                onLeftSwipe: () => onMessageSwipe(
                  isMe: true,
                  message: messageData.text,
                  messageEnum: messageData.type,
                ),
              );
            }
            return SenderMessageCard(
              message: messageData.text,
              date: DateFormat.Hm().format(
                messageData.timeSent,
              ),
              type: messageData.type,
              userName: messageData.repliedTo,
              repliedText: messageData.repliedMessage,
              repliedMessageType: messageData.repliedmessageType,
              onRightSwipe: () => onMessageSwipe(
                isMe: false,
                message: messageData.text,
                messageEnum: messageData.type,
              ),
            );
          },
        );
      },
    );
  }
}
