import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone/colors.dart';
import 'package:flutter_whatsapp_clone/features/calls/controller/call_controller.dart';
import 'package:flutter_whatsapp_clone/features/calls/screens/call_pickup_screen.dart';
import 'package:flutter_whatsapp_clone/features/chat/widgets/bottom_chat_field.dart';
import 'package:flutter_whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:flutter_whatsapp_clone/features/chat/widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  const MobileChatScreen({
    super.key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
  });
  static const String routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;

  void makeCall(WidgetRef ref, BuildContext context) {
    ref.read(callControllerProvider).makeCall(
          context: context,
          recieverName: name,
          recieverUid: uid,
          recieverProfilePic: profilePic,
          isGroupChat: isGroupChat,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CallPickScreen(
      scaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: isGroupChat
              ? Text(name)
              : StreamBuilder(
                  stream: ref.watch(authControllerProvider).userData(uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        'Loading....',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Text('');
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name),
                          Text(
                            snapshot.data!.isOnline == true ? 'Online' : 'Offline',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () => makeCall(ref, context),
              icon: const Icon(Icons.video_call),
            ),
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(Icons.call),
            // ),
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(Icons.more_vert),
            // ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ChatList(
                  recieverId: uid,
                  isGroupChat: isGroupChat,
                ),
              ),
              BottomChatField(
                recieverUserId: uid,
                isGroupChat: isGroupChat,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
