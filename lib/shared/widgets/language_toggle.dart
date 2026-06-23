import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/locale/locale_provider.dart';
import 'package:getmarried/core/models/app_language.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/l10n/app_localizations.dart';

Future<void> _applyLocale(WidgetRef ref, String code, BuildContext? context) async {
  await ref.read(localeProvider.notifier).setLocale(Locale(code));
  try {
    await ref.read(authRepositoryProvider).updateLocale(code);
  } catch (_) {}
  ref.invalidate(appUiConfigProvider);
  if (context != null && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).languageUpdated)),
    );
  }
}

class LanguageToggle extends ConsumerWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final languagesAsync = ref.watch(languagesProvider);

    return languagesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (languages) {
        if (languages.length <= 1) return const SizedBox.shrink();

        final current = languages.firstWhere(
          (l) => l.code == locale.languageCode,
          orElse: () => languages.first,
        );

        return PopupMenuButton<String>(
          tooltip: AppLocalizations.of(context).language,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.language, size: 18),
                const SizedBox(width: 4),
                Text(current.name, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
          onSelected: (code) => _applyLocale(ref, code, context),
          itemBuilder: (context) => languages
              .map((l) => PopupMenuItem<String>(
                    value: l.code,
                    child: Text(l.name),
                  ))
              .toList(),
        );
      },
    );
  }
}

class LanguageSettingsTile extends ConsumerWidget {
  const LanguageSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final languagesAsync = ref.watch(languagesProvider);
    final l10n = AppLocalizations.of(context);

    return languagesAsync.when(
      loading: () => ListTile(leading: const Icon(Icons.language), title: Text(l10n.language)),
      error: (_, __) => ListTile(leading: const Icon(Icons.language), title: Text(l10n.language)),
      data: (languages) {
        return ListTile(
          leading: const Icon(Icons.language),
          title: Text(l10n.language),
          subtitle: Text(
            languages.firstWhere((l) => l.code == locale.languageCode, orElse: () => languages.first).name,
          ),
          trailing: DropdownButton<String>(
            value: languages.any((l) => l.code == locale.languageCode)
                ? locale.languageCode
                : languages.first.code,
            items: languages
                .map((l) => DropdownMenuItem(value: l.code, child: Text(l.name)))
                .toList(),
            onChanged: (code) {
              if (code != null) _applyLocale(ref, code, context);
            },
          ),
        );
      },
    );
  }
}
