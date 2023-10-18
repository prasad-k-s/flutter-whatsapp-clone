import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone/common/enum/message_enum.dart';
import 'package:flutter_whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:flutter_whatsapp_clone/common/repositories/common_firebase_storage_repositiry.dart';
import 'package:flutter_whatsapp_clone/common/utility/snackbar.dart';
import 'package:flutter_whatsapp_clone/models/chat_contact.dart';
import 'package:flutter_whatsapp_clone/models/group.dart';
import 'package:flutter_whatsapp_clone/models/message.dart';
import 'package:flutter_whatsapp_clone/models/user_model.dart';
import 'package:uuid/uuid.dart';

final chatRepositiryProvider = Provider(
  (ref) {
    return ChatRepository(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    );
  },
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<ChatContact>> getChatContacts() {
    return firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').snapshots().asyncMap(
      (event) async {
        List<ChatContact> contacts = [];
        for (var document in event.docs) {
          var chatContact = ChatContact.fromMap(document.data());
          var userData = await firestore.collection('users').doc(chatContact.contactId).get();
          var user = UserModel.fromMap(userData.data()!);

          contacts.add(
            ChatContact(
              name: user.name,
              profilepic: user.profilePic,
              contactId: chatContact.contactId,
              timeSent: chatContact.timeSent,
              lastMessage: chatContact.lastMessage,
            ),
          );
        }

        return contacts;
      },
    );
  }

  Stream<List<GroupChat>> getChatGroups() {
    return firestore.collection('groups').snapshots().map(
      (event) {
        List<GroupChat> groups = [];
        for (var document in event.docs) {
          var group = GroupChat.fromMap(document.data());
          if (group.membersUid.contains(auth.currentUser!.uid)) {
            groups.add(group);
          }
        }

        return groups;
      },
    );
  }

  Future<void> _saveDataToContactsSubCollection({
    required UserModel senderUserData,
    required UserModel? recieverUserData,
    required String text,
    required DateTime timeSent,
    required String recieverUserId,
    required bool isGroupChat,
  }) async {
    if (isGroupChat) {
      await firestore.collection('groups').doc(recieverUserId).update({
        'lastMessage': text,
        'timeSent': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      var recieverChatContact = ChatContact(
        name: senderUserData.name,
        profilepic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text,
      );
      await firestore.collection('users').doc(recieverUserId).collection('chats').doc(auth.currentUser!.uid).set(
            recieverChatContact.toMap(),
          );
      var senderChatContact = ChatContact(
        name: recieverUserData!.name,
        profilepic: recieverUserData.profilePic,
        contactId: recieverUserData.uid,
        timeSent: timeSent,
        lastMessage: text,
      );
      await firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(recieverUserId).set(
            senderChatContact.toMap(),
          );
    }
  }

  Future<void> _saveMessageToMessageSubCollection({
    required String recieveUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String userName,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUsername,
    required String? recieverUsername,
    required bool isGroupChat,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      recieverId: recieveUserId,
      text: text,
      messageId: messageId,
      type: messageType,
      isSeen: false,
      timeSent: timeSent,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUsername
              : recieverUsername ?? '',
      repliedmessageType: messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );
    if (isGroupChat) {
      await firestore.collection('groups').doc(recieveUserId).collection('chats').doc(messageId).set(
            message.toMap(),
          );
    } else {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieveUserId)
          .collection('messages')
          .doc(messageId)
          .set(
            message.toMap(),
          );

      await firestore
          .collection('users')
          .doc(recieveUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .set(
            message.toMap(),
          );
    }
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? recieverUserData;
      if (!isGroupChat) {
        var userDataMap = await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      var messageId = const Uuid().v1();
      _saveDataToContactsSubCollection(
        senderUserData: senderUser,
        recieverUserData: recieverUserData,
        timeSent: timeSent,
        text: text,
        recieverUserId: recieverUserId,
        isGroupChat: isGroupChat,
      );
      _saveMessageToMessageSubCollection(
        recieveUserId: recieverUserId,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUser.name,
        messageType: MessageEnum.text,
        messageReply: messageReply,
        senderUsername: senderUser.name,
        recieverUsername: recieverUserData?.name,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      if (context.mounted) {
        showSnackbar(context: context, text: e.toString(), contentType: ContentType.failure, title: 'Oh no!');
      }
    }
  }

  Stream<List<Message>> getChatMessages(String recieverId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map(
      (event) {
        List<Message> messages = [];
        for (var document in event.docs) {
          messages.add(
            Message.fromMap(
              document.data(),
            ),
          );
        }
        return messages;
      },
    );
  }

  Stream<List<Message>> getGroupChatMessages(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy(
          'timeSent',
        )
        .snapshots()
        .map(
      (event) {
        List<Message> messages = [];
        for (var document in event.docs) {
          messages.add(
            Message.fromMap(
              document.data(),
            ),
          );
        }
        return messages;
      },
    );
  }

  Future<void> sendFileMessage({
    required BuildContext context,
    required File file,
    required String recieverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String url = await ref.read(commmonFirebaseStorageRepositoryProvider).storeFileToFirebase(
            'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
            file,
          );
      UserModel? recieverUserData;
      if (!isGroupChat) {
        var userDataMap = await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);
      }
      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📸 photo';
          break;
        case MessageEnum.video:
          contactMsg = '🎥 video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎤 video';
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'GIF';
          break;
      }

      await _saveDataToContactsSubCollection(
        senderUserData: senderUserData,
        recieverUserData: recieverUserData,
        text: contactMsg,
        timeSent: timeSent,
        recieverUserId: recieverUserId,
        isGroupChat: isGroupChat,
      );

      await _saveMessageToMessageSubCollection(
        recieveUserId: recieverUserId,
        text: url,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUserData.name,
        messageType: messageEnum,
        messageReply: messageReply,
        senderUsername: senderUserData.name,
        recieverUsername: recieverUserData?.name,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      if (context.mounted) {
        showSnackbar(context: context, text: e.toString(), contentType: ContentType.failure, title: 'Oh no!');
      }
    }
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String recieverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? recieverUserData;
      if (!isGroupChat) {
        var userDataMap = await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);
      }
      var messageId = const Uuid().v1();
      _saveDataToContactsSubCollection(
        senderUserData: senderUser,
        recieverUserData: recieverUserData,
        timeSent: timeSent,
        text: "GIF",
        recieverUserId: recieverUserId,
        isGroupChat: isGroupChat,
      );
      _saveMessageToMessageSubCollection(
        recieveUserId: recieverUserId,
        text: gifUrl,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUser.name,
        messageType: MessageEnum.gif,
        messageReply: messageReply,
        senderUsername: senderUser.name,
        recieverUsername: recieverUserData?.name,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      if (context.mounted) {
        showSnackbar(context: context, text: e.toString(), contentType: ContentType.failure, title: 'Oh no!');
      }
    }
  }

  void setChatMessageSeen({
    required BuildContext context,
    required String recieveUserId,
    required String messageId,
  }) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieveUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection('users')
          .doc(recieveUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      if (context.mounted) {
        showSnackbar(
          context: context,
          text: e.toString(),
          contentType: ContentType.failure,
          title: 'Oh no!',
        );
      }
    }
  }
}
