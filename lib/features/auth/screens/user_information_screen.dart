import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_whatsapp_clone/common/utility/pick_image.dart';
import 'package:flutter_whatsapp_clone/common/utility/snackbar.dart';
import 'package:flutter_whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:flutter_whatsapp_clone/features/auth/repository/auth_repository.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  const UserInformationScreen({super.key});
  static const String routeName = '/user-information';

  @override
  ConsumerState<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  File? image;
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  final myKey = GlobalKey<FormState>();

  void done() {
    final isValid = myKey.currentState!.validate();

    if (isValid) {
      if (image == null) {
        showSnackbar(
            context: context, text: 'Please pick an profile image', contentType: ContentType.warning, title: 'Pick image');
      } else {
        storeUserData();
      }
    }
  }

  void storeUserData() async {
    ref.read(authControllerProvider).saveUserDataToFirebase(name: nameController.text, profilepic: image, context: context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLoading = ref.watch(authRepositoryProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                            radius: 64,
                            backgroundColor: Colors.grey,
                            backgroundImage: image == null
                                ? const AssetImage('assets/240_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg')
                                : Image.file(image!).image),
                        Positioned(
                          left: 80,
                          bottom: -10,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(
                              Icons.add_a_photo,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: size.width * 0.85,
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: myKey,
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your name';
                                }
                                if (value.trim().length < 4) {
                                  return 'Name should have atleast 4 characters';
                                }

                                return null;
                              },
                              controller: nameController,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                hintText: 'Enter your name',
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: done,
                          icon: const Icon(
                            Icons.done,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
