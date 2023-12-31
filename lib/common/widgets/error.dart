import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/colors.dart';

class MyErrorWidget extends StatelessWidget {
  const MyErrorWidget({super.key, required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error,
        style: const TextStyle(
          fontSize: 16,
          color: redolor,
        ),
      ),
    );
  }
}
