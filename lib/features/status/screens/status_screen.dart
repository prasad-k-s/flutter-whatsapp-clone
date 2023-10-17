import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/models/status_model.dart';

import 'package:story_view/story_view.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key, required this.status});
  final Status status;
  static const String routeName = '/status-screen';

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  StoryController controller = StoryController();
  List<StoryItem> storyItems = [];
  @override
  void initState() {
    initStoryPageItems();
    super.initState();
  }

  void initStoryPageItems() {
    for (String status in widget.status.photoUrl) {
      storyItems.add(
        StoryItem.pageImage(
          url: status,
          controller: controller,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (storyItems.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return StoryView(
        storyItems: storyItems,
        controller: controller,
        onComplete: () {
          Navigator.pop(context);
        },
        onVerticalSwipeComplete: (direction) {
          if (direction == Direction.down) {
            Navigator.pop(context);
          }
        },
      );
    }
  }
}
