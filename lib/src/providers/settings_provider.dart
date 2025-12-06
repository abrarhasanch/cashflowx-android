import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/controllers/auth_controller.dart';
import '../auth/data/auth_repository.dart';
import '../models/app_user.dart';

final settingsControllerProvider = StateNotifierProvider<SettingsController, AsyncValue<void>>((ref) {
  return SettingsController(ref.watch(authRepositoryProvider));
});

class SettingsController extends StateNotifier<AsyncValue<void>> {
  SettingsController(this._repository) : super(const AsyncData(null));

  final AuthRepository _repository;

  Future<void> updateCurrency(dynamic user, String currency) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final appUser = AppUser(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoUrl: user.photoURL,
        defaultCurrency: currency,
      );
      await _repository.updateUser(appUser);
    });
  }
}
