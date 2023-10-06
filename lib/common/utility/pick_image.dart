import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/common/utility/snackbar.dart';

Future<File?> pickImage(BuildContext context) async {
  File? image;

  try {
    var res = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (res != null) {
      image = File(res.files.first.path!);
    }
  } catch (e) {
    if (context.mounted) {
      showSnackbar(
        context: context,
        text: e.toString(),
        contentType: ContentType.failure,
        title: 'Oh snap!',
      );
    }
  }
  return image;
}
