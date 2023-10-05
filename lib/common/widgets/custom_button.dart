import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.text, required this.onPressed, required this.fontsize});
  final String text;
  final VoidCallback onPressed;
  final double fontsize;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: tabColor,
        minimumSize: const Size(
          double.infinity,
          50,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: blackColor,
          fontSize: fontsize,
        ),
      ),
    );
  }
}
