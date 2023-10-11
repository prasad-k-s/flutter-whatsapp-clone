import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/colors.dart';
import 'package:flutter_whatsapp_clone/common/enum/message_enum.dart';
import 'package:flutter_whatsapp_clone/widgets/video_player_item.dart';

class DisplayMessage extends StatelessWidget {
  const DisplayMessage({
    super.key,
    required this.message,
    required this.type,
  });

  final String message;
  final MessageEnum type;

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    if (type == MessageEnum.text) {
      return Text(
        message,
        style: const TextStyle(
          fontSize: 16,
        ),
      );
    }
    if (type == MessageEnum.image) {
      return CachedNetworkImage(
        imageUrl: message,
        placeholder: (context, url) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        errorWidget: (context, url, error) {
          return Text(
            error.toString(),
            style: const TextStyle(
              fontSize: 18,
              color: redolor,
            ),
          );
        },
      );
    }
    if (type == MessageEnum.video) {
      return VideoPlayerItem(
        url: message,
      );
    }
    if (type == MessageEnum.gif) {
      return CachedNetworkImage(
        imageUrl: message,
        placeholder: (context, url) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        errorWidget: (context, url, error) {
          return Text(
            error.toString(),
          );
        },
      );
    }
    if (type == MessageEnum.audio) {
      return StatefulBuilder(
        builder: (context, setState) {
          return IconButton(
            constraints: const BoxConstraints(
              minWidth: 70,
            ),
            onPressed: () async {
              if (isPlaying) {
                await audioPlayer.pause();
                setState(() {
                  isPlaying = false;
                });
              } else {
                await audioPlayer.play(
                  UrlSource(message),
                );
                setState(() {
                  isPlaying = true;
                });
              }
            },
            icon: Icon(
              isPlaying ? Icons.pause_circle : Icons.play_circle,
              size: 35,
            ),
          );
        },
      );
    }
    return Text(
      message.toString(),
      style: const TextStyle(
        fontSize: 16,
      ),
    );
  }
}
