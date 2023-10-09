import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone/common/widgets/error.dart';
import 'package:flutter_whatsapp_clone/features/select_contacts/controller/contacts_controller.dart';

class SelectContactsScreen extends ConsumerWidget {
  const SelectContactsScreen({super.key});
  static const String routeName = '/select-contact';

  void selectContact(WidgetRef ref, Contact selectContact, BuildContext context) {
    ref.read(selectContactControllerProvider).selectContact(selectContact, context);
    
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contacts'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SafeArea(
          child: ref.watch(getContactsProvider(context)).when(
        data: (contacts) {
          if (contacts.isEmpty) {
            return const Center(
              child: Text(
                'You don\'t have any contacts',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () =>selectContact(ref,contact,context),
                    leading: contact.photo != null
                        ? CircleAvatar(
                            backgroundImage: Image.memory(contact.photo!).image,
                            radius: 30,
                          )
                        : CircleAvatar(
                            backgroundImage:
                                Image.asset('assets/240_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg').image,
                            radius: 30,
                          ),
                    title: Text(
                      contact.displayName,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
            );
          }
        },
        error: (error, stackTrace) {
          return MyErrorWidget(error: error.toString());
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )),
    );
  }
}
