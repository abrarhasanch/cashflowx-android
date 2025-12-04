import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'src/app.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
      runApp(const ProviderScope(child: CashFlowXApp()));
    },
    (object, stackTrace) => debugPrint('Uncaught error: $object'),
  );
}
