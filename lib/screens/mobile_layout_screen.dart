import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone/colors.dart';
import 'package:flutter_whatsapp_clone/common/utility/pick_image.dart';
import 'package:flutter_whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:flutter_whatsapp_clone/features/group/screens/create_group_screen.dart';
import 'package:flutter_whatsapp_clone/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:flutter_whatsapp_clone/features/chat/widgets/contacts_list.dart';
import 'package:flutter_whatsapp_clone/features/status/screens/confirm_status_screen.dart';
import 'package:flutter_whatsapp_clone/features/status/screens/status_screen_contatcts.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    tabController = TabController(length: 3, vsync: this);
    ref.read(authControllerProvider).setUserState(true);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
        ref.read(authControllerProvider).setUserState(false);
        break;
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
      case AppLifecycleState.hidden:
        ref.read(authControllerProvider).setUserState(false);
        break;
      case AppLifecycleState.detached:
        ref.read(authControllerProvider).setUserState(false);
        break;
      default:
        ref.read(authControllerProvider).setUserState(true);
        break;
    }
  }

  late TabController tabController;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: const Text(
            'WhatsApp',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            // IconButton(
            //   icon: const Icon(Icons.more_vert, color: Colors.grey),
            //   onPressed: () {},
            // ),
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () => Navigator.of(context).pushNamed(CreateGroupScreen.routeName),
                    child: const Text('Create Group'),
                  ),
                ];
              },
            ),
          ],
          bottom: TabBar(
            controller: tabController,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            ContactsList(),
            StatusContatctsScreen(),
            Center(
              child: Text('Calls'),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (tabController.index == 0) {
              Navigator.of(context).pushNamed(SelectContactsScreen.routeName);
            } else {
              File? pickedImage = await pickImage(context);
              if (pickedImage != null && context.mounted) {
                Navigator.of(context).pushNamed(ConfirmStatusScreen.routeName, arguments: pickedImage);
              }
            }
          },
          backgroundColor: tabColor,
          child: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
