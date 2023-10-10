import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerItem extends StatefulWidget {
  const VideoPlayerItem({super.key, required this.url});
  final String url;

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerController videoPlayerController;

  @override
  void initState() {
    initializeVideo();
    super.initState();
  }

  void initializeVideo() async {
    videoPlayerController = CachedVideoPlayerController.network(
      widget.url,
    );
    await videoPlayerController.initialize();
    videoPlayerController.setVolume(1);
    setState(() {});
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (!videoPlayerController.value.isInitialized) || videoPlayerController.value.isBuffering
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : AspectRatio(
            aspectRatio: videoPlayerController.value.aspectRatio,
            child: Stack(
              children: [
                CachedVideoPlayer(
                  videoPlayerController,
                ),
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        videoPlayerController.value.isPlaying ? videoPlayerController.pause() : videoPlayerController.play();
                      });
                    },
                    icon: Icon(
                      videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_circle,
                      size: 50,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
