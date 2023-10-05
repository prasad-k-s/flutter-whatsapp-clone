import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/colors.dart';
import 'package:flutter_whatsapp_clone/features/auth/screens/login_screen.dart';
import 'package:flutter_whatsapp_clone/features/auth/screens/otp_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) {
          return const LoginScreen();
        },
      );
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) {
          return OTPScreen(
            verificationId: verificationId,
          );
        },
      );
    default:
      return MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            backgroundColor: backgroundColor,
            body: ErrorWidget('Page not found'),
          );
        },
      );
  }
}