import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone/common/utility/snackbar.dart';
import 'package:flutter_whatsapp_clone/models/user_model.dart';
import 'package:flutter_whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';

final selectContatctsRepositoryProvider = Provider<SelectContactReposioty>((ref) {
  return SelectContactReposioty(firestore: FirebaseFirestore.instance);
});

class SelectContactReposioty {
  final FirebaseFirestore firestore;
  SelectContactReposioty({required this.firestore});

  Future<List<Contact>> getContacts(BuildContext context) async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      if (context.mounted) {
        showSnackbar(context: context, text: e.toString(), contentType: ContentType.failure, title: 'Oh no!');
      }
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectPhoneNumber = selectContact.phones[0].number.replaceAll(' ', '');
        if (selectPhoneNumber == userData.phoneNumber) {
          isFound = true;
          if (context.mounted) {
            Navigator.of(context).pushNamed(MobileChatScreen.routeName, arguments: {
              'name': userData.name,
              'uid': userData.uid,
            });
          }
        }
      }
      if (!isFound && context.mounted) {
        showSnackbar(
            context: context,
            text: 'This number does not exist on the app',
            contentType: ContentType.failure,
            title: 'Oh no!');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackbar(context: context, text: e.toString(), contentType: ContentType.failure, title: 'Oh no!');
      }
    }
  }
}
