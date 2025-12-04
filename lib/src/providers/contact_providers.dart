import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/contact.dart';
import '../services/firestore_service.dart';
import 'firestore_service_provider.dart';

final contactsProvider = StreamProvider.autoDispose.family<List<Contact>, (String shelfId, String bookId)>((ref, key) {
  final (shelfId, bookId) = key;
  if (shelfId.isEmpty || bookId.isEmpty) {
    return Stream<List<Contact>>.empty();
  }
  return ref.watch(firestoreServiceProvider).watchContacts(shelfId: shelfId, bookId: bookId);
});

final contactControllerProvider = StateNotifierProvider<ContactController, AsyncValue<void>>((ref) {
  return ContactController(ref.watch(firestoreServiceProvider));
});

class ContactController extends StateNotifier<AsyncValue<void>> {
  ContactController(this._service) : super(const AsyncData(null));

  final FirestoreService _service;

  Future<void> upsert(Contact contact) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _service.upsertContact(contact));
  }

  Future<void> delete(String shelfId, String bookId, String contactId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _service.deleteContact(shelfId: shelfId, bookId: bookId, contactId: contactId));
  }
}
