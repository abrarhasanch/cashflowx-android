import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/app_user.dart';

class AuthRepository {
  AuthRepository(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<AppUser?> watchCurrentUser() {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }
      final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (doc.exists) {
        return AppUser.fromJson({...doc.data()!, 'uid': doc.id});
      }
      final newUser = AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
        createdAt: DateTime.now(),
      );
      await _firestore.collection('users').doc(firebaseUser.uid).set(newUser.toJson());
      return newUser;
    });
  }

  Future<void> signIn({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp({required String email, required String password, String? name}) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = credential.user;
    if (user == null) return;
    await user.updateDisplayName(name);
    final appUser = AppUser(
      uid: user.uid,
      email: user.email ?? email,
      displayName: name,
      createdAt: DateTime.now(),
    );
    await _firestore.collection('users').doc(user.uid).set(appUser.toJson());
  }

  Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      final cred = await _auth.signInWithPopup(provider);
      if (cred.user != null) {
        await _ensureUserDocument(cred.user!);
      }
      return;
    }

    // Mobile/desktop
    final googleSignIn = GoogleSignIn(
      scopes: const ['email', 'profile'],
      serverClientId: !kIsWeb && Platform.isIOS ? _auth.app.options.iosClientId : null,
    );
    final account = await googleSignIn.signIn();
    if (account == null) return;
    final auth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    final result = await _auth.signInWithCredential(credential);
    if (result.user != null) {
      await _ensureUserDocument(result.user!);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    // Also disconnect from Google to avoid stale sessions
    final google = GoogleSignIn();
    if (await google.isSignedIn()) {
      await google.disconnect();
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUser(AppUser user) {
    return _firestore.collection('users').doc(user.uid).update(user.toJson());
  }

  Future<void> _ensureUserDocument(User firebaseUser) async {
    final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
    if (doc.exists) return;

    final newUser = AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      createdAt: DateTime.now(),
    );
    await _firestore.collection('users').doc(firebaseUser.uid).set(newUser.toJson());
  }
}
