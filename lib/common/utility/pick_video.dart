import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/common/utility/snackbar.dart';

Future<File?> pickVideo(BuildContext context) async {
  File? video;

  try {
    var res = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );
    if (res != null) {
      video = File(res.files.first.path!);
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
  return video;
}
