import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone/features/select_contacts/repository/contacts_repository.dart';

final getContactsProvider = FutureProvider.family((ref, BuildContext context) {
  final selectContactRepository = ref.watch(selectContatctsRepositoryProvider);
  return selectContactRepository.getContacts(context);
});
final selectContactControllerProvider = Provider((ref) {
  final selectContactReposioty = ref.watch(selectContatctsRepositoryProvider);
  return SelectContactController(
    ref: ref,
    selectContactReposioty: selectContactReposioty,
  );
});

class SelectContactController {
  final ProviderRef ref;
  final SelectContactReposioty selectContactReposioty;

  SelectContactController({required this.ref, required this.selectContactReposioty});

  void selectContact(Contact selectContact, BuildContext context) {
    selectContactReposioty.selectContact(selectContact, context);
  }
}
