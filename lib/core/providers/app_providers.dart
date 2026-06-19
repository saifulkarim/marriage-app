import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/auth/token_storage.dart';
import 'package:getmarried/features/auth/auth_repository.dart';
import 'package:getmarried/features/billing/billing_repository.dart';
import 'package:getmarried/features/interaction/interaction_repository.dart';
import 'package:getmarried/features/meta/meta_repository.dart';
import 'package:getmarried/features/profile/profile_repository.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.read(tokenStorageProvider));
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

final sessionProvider = FutureProvider<bool>((ref) async {
  return ref.read(authRepositoryProvider).hasSession();
});

final currentUserProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.read(authRepositoryProvider).me();
});
