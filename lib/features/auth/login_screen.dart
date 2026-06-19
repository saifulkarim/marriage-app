import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/features/auth/forgot_password_screen.dart';
import 'package:getmarried/features/auth/otp_verification_screen.dart';
import 'package:getmarried/features/home/home_shell.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isRegister = false;
  bool _loading = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final auth = ref.read(authRepositoryProvider);
      Map<String, dynamic> data;

      if (_isRegister) {
        data = await auth.register(
          name: _nameController.text.trim(),
          identifier: _identifierController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        data = await auth.login(
          identifier: _identifierController.text.trim(),
          password: _passwordController.text,
        );
      }

      ref.invalidate(sessionProvider);
      ref.invalidate(currentUserProvider);

      if (!mounted) return;

      final needsVerification = data['requires_verification'] == true;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => needsVerification
              ? const OtpVerificationScreen()
              : const BootstrapScreen(),
        ),
      );
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.favorite, size: 64, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 16),
                  Text('GetMarried',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(_isRegister ? 'নতুন অ্যাকাউন্ট তৈরি করুন' : 'লগইন করুন', textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  if (_isRegister) ...[
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'নাম', border: OutlineInputBorder()),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'নাম দিন' : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextFormField(
                    controller: _identifierController,
                    decoration: const InputDecoration(labelText: 'ইমেইল বা মোবাইল', border: OutlineInputBorder()),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'ইমেইল বা মোবাইল দিন' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'পাসওয়ার্ড', border: OutlineInputBorder()),
                    validator: (v) => (v == null || v.length < 8) ? 'কমপক্ষে ৮ অক্ষর' : null,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(_isRegister ? 'রেজিস্টার' : 'লগইন'),
                  ),
                  TextButton(
                    onPressed: _loading ? null : () => setState(() => _isRegister = !_isRegister),
                    child: Text(_isRegister ? 'ইতিমধ্যে অ্যাকাউন্ট আছে? লগইন' : 'নতুন অ্যাকাউন্ট? রেজিস্টার'),
                  ),
                  if (!_isRegister)
                    TextButton(
                      onPressed: _loading
                          ? null
                          : () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                              ),
                      child: const Text('পাসওয়ার্ড ভুলে গেছেন?'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BootstrapScreen extends ConsumerWidget {
  const BootstrapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => const LoginScreen(),
      data: (user) {
        if (user['email_verified'] != true) {
          return const OtpVerificationScreen();
        }
        return const HomeShell();
      },
    );
  }
}
