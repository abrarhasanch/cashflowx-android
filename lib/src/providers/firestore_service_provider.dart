import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/firestore_service.dart';
import 'firebase_providers.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final dynamicLinks = FirebaseDynamicLinks.instance;
  return FirestoreService(firestore, dynamicLinks);
});
