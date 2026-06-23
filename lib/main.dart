import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/core/locale/locale_provider.dart';
import 'package:getmarried/core/theme/app_theme.dart';
import 'package:getmarried/features/auth/login_screen.dart';
import 'package:getmarried/l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: GetMarriedApp()));
}

class GetMarriedApp extends ConsumerWidget {
  const GetMarriedApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final uiConfig = ref.watch(appUiConfigProvider);
    final locale = ref.watch(localeProvider);

    final theme = uiConfig.maybeWhen(
      data: (config) => AppTheme.fromConfig(config),
      orElse: () => AppTheme.light,
    );

    final config = uiConfig.maybeWhen(data: (c) => c, orElse: () => null);

    if (config?.maintenanceEnabled == true) {
      final maintenanceMsg = config?.maintenanceMessage ??
          (locale.languageCode == 'bn'
              ? 'অ্যাপ রক্ষণাবেক্ষণে আছে। পরে আবার চেষ্টা করুন।'
              : 'App is under maintenance. Please try again later.');
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localeResolutionCallback: (deviceLocale, supported) {
          for (final s in supported) {
            if (s.languageCode == locale.languageCode) return s;
          }
          return supported.firstWhere(
            (l) => l.languageCode == 'en',
            orElse: () => supported.first,
          );
        },
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(maintenanceMsg, textAlign: TextAlign.center),
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      title: config?.appName ?? 'GetMarried',
      debugShowCheckedModeBanner: false,
      theme: theme,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (deviceLocale, supported) {
        for (final s in supported) {
          if (s.languageCode == locale.languageCode) return s;
        }
        return supported.firstWhere(
          (l) => l.languageCode == 'en',
          orElse: () => supported.first,
        );
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: session.when(
        data: (loggedIn) => loggedIn ? const BootstrapScreen() : const LoginScreen(),
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (_, _) => const LoginScreen(),
      ),
    );
  }
}
