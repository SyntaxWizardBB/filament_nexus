import 'package:filament_nexus/app/services/auth_service.dart';
import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:filament_nexus/app/theme/app_radii.dart';
import 'package:filament_nexus/app/utils/validators.dart';
import 'package:flutter/material.dart';

/// Combined login / registration screen. Shown by the AuthGate whenever no
/// user is signed in.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _isRegister = false;
  bool _isLoading = false;
  bool _showPassword = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String? _validationError() {
    if (_isRegister) {
      final nameError = Validators.requiredText(_name.text, field: 'Name');
      if (nameError != null) return nameError;
    }
    final base =
        Validators.requiredText(_email.text, field: 'E-Mail') ??
        Validators.email(_email.text) ??
        Validators.requiredText(_password.text, field: 'Passwort');
    if (base != null) return base;

    if (_isRegister) {
      return Validators.passwordStrength(
            _password.text,
            message: 'Passwort ist zu schwach',
          ) ??
          Validators.match(
            _password.text,
            _confirm.text,
            message: 'Passwörter stimmen nicht überein',
          );
    }
    return null;
  }

  Future<void> _submit() async {
    final error = _validationError();
    if (error != null) {
      _showError(error);
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (_isRegister) {
        await AuthService.instance.register(
          name: _name.text,
          email: _email.text,
          password: _password.text,
        );
      } else {
        await AuthService.instance.login(
          email: _email.text,
          password: _password.text,
        );
      }
      // On success the AuthGate rebuilds automatically — nothing else to do.
    } on AuthException catch (e) {
      _showError(e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleMode() {
    setState(() => _isRegister = !_isRegister);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Filament Nexus',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isRegister ? 'Konto erstellen' : 'Anmelden',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 32),
                if (_isRegister) ...[
                  _Field(controller: _name, hint: 'Name'),
                  const SizedBox(height: 16),
                ],
                _Field(
                  controller: _email,
                  hint: 'E-Mail',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _Field(
                  controller: _password,
                  hint: 'Passwort',
                  obscure: !_showPassword,
                  suffix: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.bg600,
                    ),
                    onPressed: () =>
                        setState(() => _showPassword = !_showPassword),
                  ),
                ),
                if (_isRegister) ...[
                  const SizedBox(height: 16),
                  _Field(
                    controller: _confirm,
                    hint: 'Passwort bestätigen',
                    obscure: !_showPassword,
                  ),
                ],
                const SizedBox(height: 32),
                SizedBox(
                  height: 50,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_isRegister ? 'Registrieren' : 'Anmelden'),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _isLoading ? null : _toggleMode,
                  child: Text(
                    _isRegister
                        ? 'Schon ein Konto? Anmelden'
                        : 'Noch kein Konto? Registrieren',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffix;

  const _Field({
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.keyboardType,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.bg600),
        filled: true,
        fillColor: AppColors.bg500,
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.rounded),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
