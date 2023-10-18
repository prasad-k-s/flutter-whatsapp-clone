import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone/colors.dart';
import 'package:flutter_whatsapp_clone/common/utility/pick_image.dart';
import 'package:flutter_whatsapp_clone/common/utility/snackbar.dart';
import 'package:flutter_whatsapp_clone/features/group/controller/group_controller.dart';
import 'package:flutter_whatsapp_clone/features/group/widgets/select_contacst_group.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});
  static const String routeName = '/create-group';
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  File? image;
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  void createGroup() {
    final isValid = myKey.currentState!.validate();
    if (isValid) {
      if (image != null) {
        ref.read(groupControllerProvider).createGroup(
              context,
              groupNameController.text,
              image!,
              ref.read(
                selectedGroupContactsProvider,
              ),
            );
        ref.read(selectedGroupContactsProvider.notifier).update((state) => []);
        Navigator.pop(context);
      } else {
        showSnackbar(
          context: context,
          text: 'Pick a group profile image',
          contentType: ContentType.warning,
          title: 'pick image',
        );
      }
    }
  }

  final TextEditingController groupNameController = TextEditingController();
  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

  final myKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Create Group'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
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
              Form(
                key: myKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter group name';
                      }
                      if (value.trim().length < 4) {
                        return 'Group name should have atleast 4 characters';
                      }

                      return null;
                    },
                    controller: groupNameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: 'Enter Group Name',
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Select Contacts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SelectContactsGroup(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createGroup(),
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
