import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone/common/utility/snackbar.dart';
import 'package:flutter_whatsapp_clone/models/call.dart';

final callRepositoryProvider = Provider(
  (ref) {
    return CallRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    );
  },
);

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CallRepository({
    required this.firestore,
    required this.auth,
  });

  void makeCall({
    required BuildContext context,
    required Call senderCallData,
    required Call recieverCallData,
  }) async {
    try {
      await firestore.collection('call').doc(senderCallData.callerId).set(
            senderCallData.toMap(),
          );
      await firestore.collection('call').doc(senderCallData.receiverId).set(
            recieverCallData.toMap(),
          );
    } catch (e) {
      if (context.mounted) {
        showSnackbar(
          context: context,
          text: e.toString(),
          contentType: ContentType.failure,
          title: 'Oh no',
        );
      }
    }
  }

  Stream<DocumentSnapshot> get callStream => firestore.collection('call').doc(auth.currentUser!.uid).snapshots();
}
