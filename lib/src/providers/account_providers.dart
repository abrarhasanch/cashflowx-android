import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/controllers/auth_controller.dart';
import '../models/account.dart';
import '../models/member.dart';
import '../services/firestore_service.dart';
import 'firebase_providers.dart';
import 'firestore_service_provider.dart';

/// Stream all accounts for the current user
final accountsProvider = StreamProvider<List<Account>>((ref) {
  final userAsync = ref.watch(authStateChangesProvider);
  final user = userAsync.valueOrNull;
  if (user == null) return const Stream.empty();
  
  final service = ref.watch(firestoreServiceProvider);
  return service.watchAccountsForUser(user.uid);
});

/// Get a specific account by ID
final accountDetailProvider = StreamProvider.family<Account?, String>((ref, accountId) {
  if (accountId.isEmpty) return const Stream.empty();
  
  final service = ref.watch(firestoreServiceProvider);
  return service.watchAccount(accountId);
});

/// Controller for account CRUD operations
final accountControllerProvider = StateNotifierProvider<AccountController, AsyncValue<Account?>>((ref) {
  return AccountController(ref.watch(firestoreServiceProvider), ref.watch(firebaseAuthProvider));
});

class AccountController extends StateNotifier<AsyncValue<Account?>> {
  AccountController(this._service, this._auth) : super(const AsyncData(null));

  final FirestoreService _service;
  final FirebaseAuth _auth;

  Future<Account?> createAccount(String title, String description, String currency) async {
    state = const AsyncLoading();
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      final account = Account(
        id: '',
        title: title,
        description: description,
        currency: currency,
        ownerUid: user.uid,
        createdAt: DateTime.now(),
        members: [AccountMember(uid: user.uid, role: MemberRole.owner)],
        memberUids: [user.uid],
      );

      final createdAccount = await _service.createAccount(account);
      state = AsyncData(createdAccount);
      return createdAccount;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return null;
    }
  }

  Future<bool> updateAccount(Account account) async {
    state = const AsyncLoading();
    try {
      await _service.updateAccount(account);
      state = AsyncData(account);
      return true;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return false;
    }
  }

  Future<bool> deleteAccount(String accountId) async {
    state = const AsyncLoading();
    try {
      await _service.deleteAccount(accountId);
      state = const AsyncData(null);
      return true;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return false;
    }
  }

  Future<String> generateInviteLink(String accountId) async {
    state = const AsyncLoading();
    try {
      final link = await _service.generateInviteLink(accountId);
      state = const AsyncData(null);
      return link;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  Future<bool> addMember(String accountId, String memberUid, MemberRole role) async {
    try {
      await _service.addMember(accountId, memberUid, role);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeMember(String accountId, String memberUid) async {
    try {
      await _service.removeMember(accountId, memberUid);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateMemberRole(String accountId, String memberUid, MemberRole newRole) async {
    try {
      await _service.updateMemberRole(accountId, memberUid, newRole);
      return true;
    } catch (e) {
      return false;
    }
  }
}
