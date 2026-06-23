import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getmarried/core/api/api_client.dart';
import 'package:getmarried/core/config/app_config.dart';
import 'package:getmarried/core/providers/app_providers.dart';
import 'package:getmarried/core/theme/app_colors.dart';
import 'package:getmarried/features/auth/forgot_password_screen.dart';
import 'package:getmarried/features/auth/otp_verification_screen.dart';
import 'package:getmarried/core/locale/locale_provider.dart';
import 'package:getmarried/features/home/home_shell.dart';
import 'package:getmarried/l10n/app_localizations.dart';
import 'package:getmarried/shared/widgets/app_logo.dart';
import 'package:getmarried/shared/widgets/language_toggle.dart';

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
  bool _googleLoading = false;

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

  Future<void> _googleSignIn() async {
    if (!AppConfig.isGoogleSignInConfigured) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google Sign-In not configured. Set GOOGLE_SERVER_CLIENT_ID when running the app.'),
        ),
      );
      return;
    }

    setState(() => _googleLoading = true);
    try {
      final account = await ref.read(googleAuthServiceProvider).signIn();
      if (account == null) return;

      final email = account.email;
      if (email.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Google account email is required')),
          );
        }
        return;
      }

      final data = await ref.read(authRepositoryProvider).googleLogin(
            providerId: account.id,
            email: email,
            name: account.displayName ?? email,
          );

      ref.invalidate(sessionProvider);
      ref.invalidate(currentUserProvider);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => data['requires_verification'] == true
              ? const OtpVerificationScreen()
              : const BootstrapScreen(),
        ),
      );
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } on StateError catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(alignment: Alignment.centerRight, child: LanguageToggle()),
                  const AppLogo(size: 28),
                  const SizedBox(height: 32),
                  Text(_isRegister ? l10n.registerTitle : l10n.loginTitle,
                      textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 32),
                  if (_isRegister) ...[
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: l10n.nameLabel, border: const OutlineInputBorder()),
                      validator: (v) => (v == null || v.trim().isEmpty) ? l10n.nameRequired : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextFormField(
                    controller: _identifierController,
                    decoration: InputDecoration(labelText: l10n.emailOrMobile, border: const OutlineInputBorder()),
                    validator: (v) => (v == null || v.trim().isEmpty) ? l10n.emailOrMobileRequired : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: l10n.password, border: const OutlineInputBorder()),
                    validator: (v) => (v == null || v.length < 8) ? l10n.passwordMin : null,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(_isRegister ? l10n.register : l10n.login),
                  ),
                  if (!_isRegister) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(l10n.or, style: Theme.of(context).textTheme.bodySmall),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: (_loading || _googleLoading) ? null : _googleSignIn,
                      icon: _googleLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.g_mobiledata, size: 28),
                      label: Text(l10n.continueWithGoogle),
                    ),
                  ],
                  TextButton(
                    onPressed: (_loading || _googleLoading) ? null : () => setState(() => _isRegister = !_isRegister),
                    child: Text(_isRegister ? l10n.alreadyHaveAccount : l10n.newAccountPrompt),
                  ),
                  if (!_isRegister)
                    TextButton(
                      onPressed: (_loading || _googleLoading)
                          ? null
                          : () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                              ),
                      child: Text(l10n.forgotPassword),
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
        final userLocale = user['locale']?.toString();
        if (userLocale != null && userLocale.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(localeProvider.notifier).setLocale(Locale(userLocale));
          });
        }
        if (user['email_verified'] != true) {
          return const OtpVerificationScreen();
        }
        return const HomeShell();
      },
    );
  }
}
