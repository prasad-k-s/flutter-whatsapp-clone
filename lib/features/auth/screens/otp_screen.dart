import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_whatsapp_clone/colors.dart';

class OTPScreen extends StatefulWidget {
  static const String routeName = '/otp-screen';
  const OTPScreen({super.key, required this.verificationId});
  final String verificationId;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: const Text(
          'Verify your number',
        ),
      ),
      body: SafeArea(
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
              onSubmit: (value) {},
              autoFocus: true,
            )
          ],
        ),
      ),
    );
  }
}
