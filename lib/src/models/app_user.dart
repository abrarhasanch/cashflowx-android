import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/timestamp_converter.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
    @Default('USD') String defaultCurrency,
    @TimestampConverter() DateTime? createdAt,
    @Default([]) List<String> shelfIds,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
}
