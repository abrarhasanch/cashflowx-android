import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/contact.dart';
import '../services/firestore_service.dart';
import 'firestore_service_provider.dart';

/// Stream all contacts for a specific account
final contactsProvider = StreamProvider.family<List<Contact>, String>((ref, accountId) {
  if (accountId.isEmpty) return const Stream.empty();
  final service = ref.watch(firestoreServiceProvider);
  return service.watchContacts(accountId);
});

/// Controller for contact operations
final contactControllerProvider = StateNotifierProvider<ContactController, AsyncValue<void>>((ref) {
  return ContactController(ref.watch(firestoreServiceProvider));
});

class ContactController extends StateNotifier<AsyncValue<void>> {
  ContactController(this._service) : super(const AsyncData(null));

  final FirestoreService _service;

  Future<void> upsertContact(Contact contact) async {
    state = const AsyncLoading();
    try {
      await _service.upsertContact(contact);
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> deleteContact(String accountId, String contactId) async {
    state = const AsyncLoading();
    try {
      await _service.deleteContact(accountId, contactId);
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}
