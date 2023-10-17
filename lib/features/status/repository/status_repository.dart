// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone/common/repositories/common_firebase_storage_repositiry.dart';
import 'package:flutter_whatsapp_clone/common/utility/snackbar.dart';
import 'package:flutter_whatsapp_clone/models/status_model.dart';
import 'package:flutter_whatsapp_clone/models/user_model.dart';
import 'package:uuid/uuid.dart';

final statusRepositoryProvider = Provider(
  (ref) {
    return StatusRepository(
      firebaseAuth: FirebaseAuth.instance,
      firebaseFirestore: FirebaseFirestore.instance,
      ref: ref,
    );
  },
);

class StatusRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final ProviderRef ref;
  StatusRepository({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.ref,
  });

  Future<void> uploadStatus({
    required String userName,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      var statusId = const Uuid().v1();
      String uid = firebaseAuth.currentUser!.uid;
      String imageUrl = await ref.read(commmonFirebaseStorageRepositoryProvider).storeFileToFirebase(
            '/status/$statusId$uid',
            statusImage,
          );
      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      List<String> uidWhoCanSee = [];
      for (var contact in contacts) {
        var userDataFirebase = await firebaseFirestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: contact.phones[0].number.replaceAll(' ', ''),
            )
            .get();
        if (userDataFirebase.docs.isNotEmpty) {
          var userData = UserModel.fromMap(
            userDataFirebase.docs[0].data(),
          );
          uidWhoCanSee.add(userData.uid);
        }
      }
      List<String> statusImageUrls = [];
      var statusesSnapshot = await firebaseFirestore
          .collection('status')
          .where(
            'uid',
            isEqualTo: firebaseAuth.currentUser!.uid,
          )
          // .where(
          //   'createdAt',
          //   isLessThan: DateTime.now().subtract(
          //     const Duration(hours: 24),
          //   ),
          // )
          .get();
      if (statusesSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(
          statusesSnapshot.docs[0].data(),
        );
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(
          imageUrl,
        );
        await firebaseFirestore
            .collection('status')
            .doc(
              statusesSnapshot.docs[0].id,
            )
            .update(
          {
            'photoUrl': statusImageUrls,
          },
        );
        return;
      } else {
        statusImageUrls = [
          imageUrl,
        ];
      }
      Status status = Status(
        uid: uid,
        username: userName,
        phoneNumber: phoneNumber,
        photoUrl: statusImageUrls,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        statusId: statusId,
        whoCanSee: uidWhoCanSee,
      );

      await firebaseFirestore.collection('status').doc(statusId).set(
            status.toMap(),
          );
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

  Future<List<Status>> getStatus({
    required BuildContext context,
  }) async {
    List<Status> statusData = [];
    try {
      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      for (var contact in contacts) {
        var statusesSnapshot = await firebaseFirestore
            .collection('status')
            .where(
              'phoneNumber',
              isEqualTo: contact.phones[0].number.replaceAll(' ', ''),
            )
            .where(
              'createdAt',
              isGreaterThan: DateTime.now()
                  .subtract(
                    const Duration(hours: 24),
                  )
                  .millisecondsSinceEpoch,
            )
            .get();

        for (var tempData in statusesSnapshot.docs) {
          Status tempStatus = Status.fromMap(tempData.data());
          if (tempStatus.whoCanSee.contains(firebaseAuth.currentUser!.uid)) {
            statusData.add(tempStatus);
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        debugPrint(
          e.toString(),
        );
        showSnackbar(
          context: context,
          text: e.toString(),
          contentType: ContentType.failure,
          title: 'Oh no!',
        );
      }
    }
    return statusData;
  }
}
