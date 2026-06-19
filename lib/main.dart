import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/features/auth/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: GetMarriedApp()));
}

class GetMarriedApp extends ConsumerWidget {
  const GetMarriedApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);

    return MaterialApp(
      title: 'GetMarried',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9B1B5A),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: session.when(
        data: (loggedIn) => loggedIn ? const BootstrapScreen() : const LoginScreen(),
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (_, _) => const LoginScreen(),
      ),
    );
  }
}
