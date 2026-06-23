import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/auth/token_storage.dart';
import 'package:getmarried/core/auth/google_auth_service.dart';
import 'package:getmarried/features/auth/auth_repository.dart';
import 'package:getmarried/features/billing/billing_repository.dart';
import 'package:getmarried/features/interaction/interaction_repository.dart';
import 'package:getmarried/core/locale/locale_provider.dart';
import 'package:getmarried/core/models/app_language.dart';
import 'package:getmarried/core/models/app_ui_config.dart';
import 'package:getmarried/features/meta/meta_repository.dart';
import 'package:getmarried/features/profile/profile_repository.dart';
import 'package:getmarried/features/shared/extra_repositories.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) => GoogleAuthService());

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    ref.read(tokenStorageProvider),
    localeResolver: () => ref.read(localeProvider).languageCode,
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(apiClientProvider), ref.read(tokenStorageProvider));
});

final metaRepositoryProvider = Provider<MetaRepository>((ref) {
  return MetaRepository(ref.read(apiClientProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.read(apiClientProvider));
});

final interactionRepositoryProvider = Provider<InteractionRepository>((ref) {
  return InteractionRepository(ref.read(apiClientProvider));
});

final billingRepositoryProvider = Provider<BillingRepository>((ref) {
  return BillingRepository(ref.read(apiClientProvider));
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.read(apiClientProvider));
});

final meetingRepositoryProvider = Provider<MeetingRepository>((ref) {
  return MeetingRepository(ref.read(apiClientProvider));
});

final complaintRepositoryProvider = Provider<ComplaintRepository>((ref) {
  return ComplaintRepository(ref.read(apiClientProvider));
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.read(apiClientProvider));
});

final photoAccessRepositoryProvider = Provider<PhotoAccessRepository>((ref) {
  return PhotoAccessRepository(ref.read(apiClientProvider));
});

final phase3RepositoryProvider = Provider<Phase3Repository>((ref) {
  return Phase3Repository(ref.read(apiClientProvider));
});

final sessionProvider = FutureProvider<bool>((ref) async {
  return ref.read(authRepositoryProvider).hasSession();
});

final currentUserProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.read(authRepositoryProvider).me();
});

final unreadNotificationCountProvider = FutureProvider<int>((ref) async {
  return ref.read(notificationRepositoryProvider).unreadCount();
});

final homeTabIndexProvider = StateProvider<int>((ref) => 0);

final appUiConfigProvider = FutureProvider<AppUiConfig>((ref) async {
  ref.watch(localeProvider);
  try {
    return await ref.read(metaRepositoryProvider).appUi();
  } catch (_) {
    return AppUiConfig.defaults;
  }
});

final languagesProvider = FutureProvider<List<AppLanguage>>((ref) async {
  try {
    final list = await ref.read(metaRepositoryProvider).languages();
    return list.map((e) => AppLanguage.fromJson(e as Map<String, dynamic>)).toList();
  } catch (_) {
    return const [
      AppLanguage(code: 'bn', name: 'বাংলা', nameEn: 'Bangla', isDefault: true),
      AppLanguage(code: 'en', name: 'English', nameEn: 'English'),
    ];
  }
});
