import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone/colors.dart';
import 'package:flutter_whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:flutter_whatsapp_clone/features/auth/repository/auth_repository.dart';

class OTPScreen extends ConsumerWidget {
  static const String routeName = '/otp-screen';
  const OTPScreen({super.key, required this.verificationId});
  final String verificationId;

  void verifyOTP(
    String userOTP,
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.read(authControllerProvider).verifyOTP(
          context: context,
          verificationId: verificationId,
          userOTP: userOTP,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: const Text(
          'Verify your number',
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('We have sent an SMS with a code'),
                  OtpTextField(
                    margin: const EdgeInsets.all(8),
                    numberOfFields: 6,
                    fieldWidth: 40,
                    keyboardType: TextInputType.number,
                    showFieldAsBox: false,
                    focusedBorderColor: tabColor,
                    mainAxisAlignment: MainAxisAlignment.center,
                    onSubmit: (value) {
                      if (value.trim().length == 6) {
                        verifyOTP(value, context, ref);
                      }
                    },
                    autoFocus: true,
                  )
                ],
              ),
            ),
    );
  }
}
