import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/colors.dart';
import 'package:flutter_whatsapp_clone/features/auth/screens/login_screen.dart';
import 'package:flutter_whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:flutter_whatsapp_clone/features/auth/screens/user_information_screen.dart';
import 'package:flutter_whatsapp_clone/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:flutter_whatsapp_clone/screens/mobile_chat_screen.dart';

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
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) {
          return const UserInformationScreen();
        },
      );
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) {
          return const SelectContactsScreen();
        },
      );
    case MobileChatScreen.routeName:
      return MaterialPageRoute(
        builder: (context) {
          final arguments = settings.arguments as Map<String, dynamic>;
          final name = arguments['name'];
          final uid = arguments['uid'];
          return MobileChatScreen(
            name: name,
            uid: uid,
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
