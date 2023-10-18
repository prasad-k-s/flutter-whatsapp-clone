import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone/common/widgets/error.dart';
import 'package:flutter_whatsapp_clone/features/select_contacts/controller/contacts_controller.dart';

final selectedGroupContactsProvider = StateProvider<List<Contact>>((ref) {
  return [];
});

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedConatctsIndex = [];

  void selectConatct(int index, Contact contact) {
    if (selectedConatctsIndex.contains(index)) {
      selectedConatctsIndex.remove(index);
    } else {
      selectedConatctsIndex.add(index);
    }
    setState(() {});
    ref.read(selectedGroupContactsProvider.notifier).update((state) => [
          ...state,
          contact,
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider(context)).when(
      data: (contacts) {
        if (contacts.isEmpty) {
          return const Text(
            'You haven\'t saved any contacts in your phone',
          );
        }
        return Expanded(
          child: ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return InkWell(
                onTap: () => selectConatct(index, contact ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8,
                  ),
                  child: ListTile(
                    title: Text(
                      contact.displayName,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    leading: selectedConatctsIndex.contains(index) ? const Icon(Icons.done) : null,
                  ),
                ),
              );
            },
          ),
        );
      },
      error: (error, stackTrace) {
        return MyErrorWidget(
          error: error.toString(),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
