import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storageKey = 'app_locale';

class LocaleStorage {
  const LocaleStorage(this._storage);

  final FlutterSecureStorage _storage;

  Future<String?> read() => _storage.read(key: _storageKey);

  Future<void> write(String code) => _storage.write(key: _storageKey, value: code);
}

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this._storage) : super(const Locale('en')) {
    _load();
  }

  final LocaleStorage _storage;

  Future<void> _load() async {
    final saved = await _storage.read();
    if (saved != null && saved.length >= 2) {
      state = Locale(saved);
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _storage.write(locale.languageCode);
  }
}

final localeStorageProvider = Provider<LocaleStorage>(
  (ref) => const LocaleStorage(FlutterSecureStorage()),
);

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(ref.read(localeStorageProvider));
});
