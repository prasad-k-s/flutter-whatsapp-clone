import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone/colors.dart';
import 'package:flutter_whatsapp_clone/common/enum/message_enum.dart';
import 'package:flutter_whatsapp_clone/common/utility/pick_image.dart';
import 'package:flutter_whatsapp_clone/common/utility/pick_video.dart';
import 'package:flutter_whatsapp_clone/features/chat/controller/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  const BottomChatField({
    required this.recieverUserId,
    super.key,
  });
  final String recieverUserId;
  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  bool isShowEmoji = false;
  FocusNode focusNode = FocusNode();
  void hideEmojiContainer() {
    setState(() {
      isShowEmoji = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmoji = true;
    });
  }

  void showKeyboard() {
    setState(() {
      focusNode.requestFocus();
    });
  }

  void hideKeyboard() {
    setState(() {
      focusNode.unfocus();
    });
  }

  void toggleEmojiKeyboard() {
    if (isShowEmoji) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  final TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  void sendTextButton() async {
    if (isShowSendButton) {
      ref.read(chatContollerProvider).sendTextMessage(
            context,
            textEditingController.text,
            widget.recieverUserId,
          );

      setState(() {
        textEditingController.clear();
      });
    }
  }

  Future<void> sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) async {
    await ref.read(chatContollerProvider).sendFileMessage(
          context,
          file,
          widget.recieverUserId,
          messageEnum,
        );
  }

  void selectImage() async {
    File? file = await pickImage(context);
    if (file != null) {
      setState(() {
        isLoading = true;
      });

      await sendFileMessage(
        file,
        MessageEnum.image,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  void selectVideo() async {
    File? file = await pickVideo(context);
    if (file != null) {
      setState(() {
        isLoading = true;
      });

      await sendFileMessage(
        file,
        MessageEnum.video,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                autofocus: true,
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                controller: textEditingController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: SizedBox(
                    width: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: toggleEmojiKeyboard,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Icon(
                                isShowEmoji ? Icons.keyboard : Icons.emoji_emotions,
                                size: 25,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.gif,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 70,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: GestureDetector(
                              onTap: selectImage,
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: selectVideo,
                            child: const Icon(
                              Icons.attach_file,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF128C7E),
                radius: 24,
                child: GestureDetector(
                  onTap: isLoading ? null : sendTextButton,
                  child: isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          isShowSendButton ? Icons.send : Icons.mic,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
          ],
        ),
        if (isShowEmoji)
          SizedBox(
            height: 310,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                setState(() {
                  textEditingController.text = textEditingController.text + emoji.emoji;
                });
                if (!isShowSendButton) {
                  setState(() {
                    isShowSendButton = !isShowSendButton;
                  });
                }
              },
            ),
          ),
      ],
    );
  }
}
