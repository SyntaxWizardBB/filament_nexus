import 'package:filament_nexus/app/services/auth_service.dart';
import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Shown when a user is signed in but has not confirmed their e-mail yet.
///
/// Firestore rules reject writes from unverified accounts, so this screen
/// gates the app until the confirmation link was clicked.
class VerifyEmailScreen extends StatefulWidget {
  /// Called once the reload confirmed the address — lets the gate rebuild.
  final VoidCallback onVerified;

  const VerifyEmailScreen({super.key, required this.onVerified});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isBusy = false;

  Future<void> _resend() async {
    setState(() => _isBusy = true);
    try {
      await AuthService.instance.sendVerificationEmail();
      _snack('Bestätigungsmail wurde erneut gesendet.');
    } on AuthException catch (e) {
      _snack(e.message);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _checkVerified() async {
    setState(() => _isBusy = true);
    await AuthService.instance.reloadUser();
    if (!mounted) return;
    setState(() => _isBusy = false);

    if (AuthService.instance.isEmailVerified) {
      widget.onVerified();
    } else {
      _snack('Noch nicht bestätigt. Bitte zuerst den Link in der Mail öffnen.');
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final email = AuthService.instance.email ?? '';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 72,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'E-Mail bestätigen',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Wir haben dir einen Bestätigungslink an\n$email gesendet.\n\n'
                  'Öffne den Link und tippe danach auf „Ich habe bestätigt".',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 50,
                  child: FilledButton(
                    onPressed: _isBusy ? null : _checkVerified,
                    child: _isBusy
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Ich habe bestätigt'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _isBusy ? null : _resend,
                  child: const Text('Mail erneut senden'),
                ),
                TextButton(
                  onPressed: _isBusy ? null : AuthService.instance.logout,
                  child: const Text('Abmelden'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
