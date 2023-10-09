import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone/features/auth/repository/auth_repository.dart';
import 'package:flutter_whatsapp_clone/models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider.notifier);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider<UserModel?>((ref) async {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({required this.ref, required this.authRepository});

  void signinWithPhone({required BuildContext context, required String phoneNumber}) {
    authRepository.signInWithPhone(phoneNumber, context);
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    authRepository.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
    );
  }

  void saveUserDataToFirebase({
    required String name,
    required File? profilepic,
    required BuildContext context,
  }) async {
    ref.read(authRepositoryProvider.notifier).saveUserDataToFirebase(
          name: name,
          profilepic: profilepic,
          context: context,
          ref: ref,
        );
  }

  Future<UserModel?> getUserData() async {
    UserModel? userModel = await authRepository.getCurrentUserData();
    return userModel;
  }

  Stream<UserModel> userData(String userId) {
    return authRepository.userData(userId);
  }
}
