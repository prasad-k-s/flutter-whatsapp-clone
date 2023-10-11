// ignore_for_file: file_names

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/common/utility/snackbar.dart';

Future<GiphyGif?> pickGIF(BuildContext context) async {
  //giphy email - gefenypi@lyft.live
  //key - U1UqcDdDARaULoalRSyHHIeJUPTDc2y3
  GiphyGif? gif;
  try {
    gif = await Giphy.getGif(
      context: context,
      apiKey: 'U1UqcDdDARaULoalRSyHHIeJUPTDc2y3',
    );
  } catch (e) {
    if (context.mounted) {
      showSnackbar(
        context: context,
        text: e.toString(),
        contentType: ContentType.failure,
        title: 'Oh no!',
      );
    }
  }
  return gif;
}
