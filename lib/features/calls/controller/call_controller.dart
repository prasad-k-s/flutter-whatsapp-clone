import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone/features/auth/controller/auth_controller.dart';

import 'package:flutter_whatsapp_clone/features/calls/repository/call_repository.dart';
import 'package:flutter_whatsapp_clone/models/call.dart';
import 'package:uuid/uuid.dart';

final callControllerProvider = Provider(
  (ref) {
    final callRepository = ref.read(callRepositoryProvider);
    return CallController(
      callRepository: callRepository,
      ref: ref,
      auth: FirebaseAuth.instance,
    );
  },
);

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;
  CallController({
    required this.callRepository,
    required this.ref,
    required this.auth,
  });

  void makeCall({
    required BuildContext context,
    required String recieverName,
    required String recieverUid,
    required String recieverProfilePic,
    required bool isGroupChat,
  }) async {
    ref.read(userDataAuthProvider).whenData(
      (value) {
        String callId = const Uuid().v1();
        Call senderCallData = Call(
            callerId: auth.currentUser!.uid,
            callerName: value!.name,
            callerPic: value.profilePic,
            receiverPic: recieverProfilePic,
            receiverName: recieverName,
            callId: callId,
            hasDialled: true,
            receiverId: recieverUid);

        Call recieverCallData = Call(
            callerId: auth.currentUser!.uid,
            callerName: value.name,
            callerPic: value.profilePic,
            receiverPic: recieverProfilePic,
            receiverName: recieverName,
            callId: callId,
            hasDialled: false,
            receiverId: recieverUid);

        callRepository.makeCall(
          context: context,
          senderCallData: senderCallData,
          recieverCallData: recieverCallData,
        );
      },
    );
  }

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;
}
