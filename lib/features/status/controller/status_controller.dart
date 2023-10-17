// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone/features/auth/controller/auth_controller.dart';

import 'package:flutter_whatsapp_clone/features/status/repository/status_repository.dart';
import 'package:flutter_whatsapp_clone/models/user_model.dart';

final statusControllerProvider = Provider(
  (ref) {
    final statusRepository = ref.read(statusRepositoryProvider);
    return StatusController(
      ref: ref,
      statusRepository: statusRepository,
    );
  },
);

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;
  StatusController({
    required this.statusRepository,
    required this.ref,
  });

  Future<void> addStatus(File file, BuildContext context) async {
    ref.watch(userDataAuthProvider).whenData(
      (UserModel? value) async {
        await statusRepository.uploadStatus(
          userName: value!.name,
          profilePic: value.profilePic,
          phoneNumber: value.phoneNumber,
          statusImage: file,
          context: context,
        );
      },
    );
  }
}
