import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/colors.dart';
import 'package:flutter_whatsapp_clone/features/auth/screens/login_screen.dart';
import 'package:flutter_whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:flutter_whatsapp_clone/features/auth/screens/user_information_screen.dart';
import 'package:flutter_whatsapp_clone/features/group/screens/create_group_screen.dart';
import 'package:flutter_whatsapp_clone/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:flutter_whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';
import 'package:flutter_whatsapp_clone/features/status/screens/confirm_status_screen.dart';
import 'package:flutter_whatsapp_clone/features/status/screens/status_screen.dart';
import 'package:flutter_whatsapp_clone/models/status_model.dart';

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
          final isGroupChat = arguments['isGroupChat'];
          final profilePic = arguments['profilePic'];
          return MobileChatScreen(
            name: name,
            uid: uid,
            isGroupChat: isGroupChat,
            profilePic: profilePic,
          );
        },
      );
    case ConfirmStatusScreen.routeName:
      return MaterialPageRoute(
        builder: (context) {
          final arguments = settings.arguments as File;

          return ConfirmStatusScreen(
            file: arguments,
          );
        },
      );
    case StatusScreen.routeName:
      return MaterialPageRoute(
        builder: (context) {
          final status = settings.arguments as Status;

          return StatusScreen(
            status: status,
          );
        },
      );
    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) {
          return const CreateGroupScreen();
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
