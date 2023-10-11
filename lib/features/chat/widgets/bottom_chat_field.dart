import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_whatsapp_clone/colors.dart';
import 'package:flutter_whatsapp_clone/common/enum/message_enum.dart';
import 'package:flutter_whatsapp_clone/common/utility/pick_GIF.dart';
import 'package:flutter_whatsapp_clone/common/utility/pick_image.dart';
import 'package:flutter_whatsapp_clone/common/utility/pick_video.dart';
import 'package:flutter_whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  bool isRecoderInit = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();
  FlutterSoundRecorder? soundRecorder;

  @override
  void initState() {
    super.initState();
    soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission denied!');
    }
    await soundRecorder!.openRecorder();
    isRecoderInit = true;
  }

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

  void selectGIF() async {
    final gif = await pickGIF(context);
    if (gif != null && context.mounted) {
      ref.read(chatContollerProvider).sendGIFMessage(
            context: context,
            gifUrl: gif.url,
            recieverUserId: widget.recieverUserId,
          );
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
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecoderInit) {
        return;
      }
      if (isRecording) {
        await soundRecorder!.stopRecorder();
        sendFileMessage(
          File(path),
          MessageEnum.audio,
        );
      } else {
        await soundRecorder!.startRecorder(
          toFile: path,
        );
      }
      setState(() {
        isRecording = !isRecording;
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
    soundRecorder!.closeRecorder();
    isRecoderInit = false;
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
                            onTap: selectGIF,
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
                          isShowSendButton
                              ? Icons.send
                              : isRecording
                                  ? Icons.close
                                  : Icons.mic,
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
