import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone/common/enum/message_enum.dart';
import 'package:flutter_whatsapp_clone/common/utility/snackbar.dart';
import 'package:flutter_whatsapp_clone/models/chat_contact.dart';
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

  void _saveDataToContactsSubCollection({
    required UserModel senderUserData,
    required UserModel recieverUserData,
    required String text,
    required DateTime timeSent,
    required String recieverUserId,
  }) async {
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
      name: recieverUserData.name,
      profilepic: recieverUserData.profilePic,
      contactId: recieverUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(recieverUserId).set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubCollection({
    required String recieveUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String userName,
    required String recieverUserName,
    required MessageEnum messageType,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      recieverId: recieveUserId,
      text: text,
      messageId: messageId,
      type: messageType,
      isSeen: false,
    );

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

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel recieverUserData;
      var userDataMap = await firestore.collection('users').doc(recieverUserId).get();
      recieverUserData = UserModel.fromMap(userDataMap.data()!);
      var messageId = const Uuid().v1();
      _saveDataToContactsSubCollection(
        senderUserData: senderUser,
        recieverUserData: recieverUserData,
        timeSent: timeSent,
        text: text,
        recieverUserId: recieverUserId,
      );
      _saveMessageToMessageSubCollection(
        recieveUserId: recieverUserId,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUser.name,
        recieverUserName: recieverUserData.name,
        messageType: MessageEnum.text,
      );
    } catch (e) {
      if (context.mounted) {
        showSnackbar(context: context, text: e.toString(), contentType: ContentType.failure, title: 'Oh no!');
      }
    }
  }
}
