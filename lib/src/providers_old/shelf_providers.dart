import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/controllers/auth_controller.dart';
import '../models/app_user.dart';
import '../models/member.dart';
import '../models/shelf.dart';
import 'firestore_service_provider.dart';
import '../services/firestore_service.dart';

final shelvesProvider = StreamProvider<List<Shelf>>((ref) {
  final user = ref.watch(authStateChangesProvider).valueOrNull;
  if (user == null) {
    return Stream<List<Shelf>>.empty();
  }
  debugPrint('📚 Watching shelves for user: ${user.uid}');
  return ref.watch(firestoreServiceProvider).watchShelvesForUser(user.uid).map((shelves) {
    debugPrint('📚 Received ${shelves.length} shelves from Firestore');
    return shelves;
  });
});

final selectedShelfIdProvider = StateProvider<String?>((ref) => null);

final shelfControllerProvider = StateNotifierProvider<ShelfController, AsyncValue<Shelf?>>((ref) {
  return ShelfController(
    ref.watch(firestoreServiceProvider),
    ref.watch(authStateChangesProvider).valueOrNull,
    ref,
  );
});

class ShelfController extends StateNotifier<AsyncValue<Shelf?>> {
  ShelfController(this._service, this._currentUser, this._ref) : super(const AsyncData(null));

  final FirestoreService _service;
  final AppUser? _currentUser;
  final Ref _ref;

  Future<Shelf?> createShelf(String title, String description, String currency) async {
    final ownerUid = _currentUser?.uid;
    if (ownerUid == null) {
      debugPrint('❌ Cannot create shelf: No user logged in');
      return null;
    }
    final shelf = Shelf(
      id: '',
      title: title,
      description: description,
      currency: currency,
      ownerUid: ownerUid,
      createdAt: DateTime.now(),
      members: [ShelfMember(uid: ownerUid, role: MemberRole.owner)],
      memberUids: [ownerUid],
    );
    state = const AsyncLoading();
    try {
      debugPrint('📚 Creating shelf: $title for user: $ownerUid');
      final createdShelf = await _service.createShelf(shelf);
      debugPrint('✅ Shelf created successfully: ${createdShelf.id}');
      state = AsyncData(createdShelf);
      // Invalidate the shelves provider to force a refresh
      _ref.invalidate(shelvesProvider);
      return createdShelf;
    } catch (e, st) {
      debugPrint('❌ Error creating shelf: $e');
      debugPrint('Stack trace: $st');
      state = AsyncError(e, st);
      return null;
    }
  }

  Future<bool> updateShelf(Shelf shelf) async {
    state = const AsyncLoading();
    try {
      await _service.updateShelf(shelf);
      state = AsyncData(shelf);
      _ref.invalidate(shelvesProvider);
      return true;
    } catch (e, st) {
      debugPrint('❌ Error updating shelf: $e');
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<bool> deleteShelf(String shelfId) async {
    state = const AsyncLoading();
    try {
      await _service.deleteShelf(shelfId);
      state = const AsyncData(null);
      _ref.invalidate(shelvesProvider);
      return true;
    } catch (e, st) {
      debugPrint('❌ Error deleting shelf: $e');
      state = AsyncError(e, st);
      return false;
    }
  }
}
