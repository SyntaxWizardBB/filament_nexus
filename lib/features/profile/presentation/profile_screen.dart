import 'package:filament_nexus/app/services/auth_service.dart';
import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:filament_nexus/app/theme/app_radii.dart';
import 'package:filament_nexus/app/utils/validators.dart';
import 'package:flutter/material.dart';

/// Profile management backed by Firebase Auth.
///
/// - Name  → `displayName` (editable)
/// - E-Mail → the login identity (read-only)
/// - Password → changed via reauthentication + `updatePassword`
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: AuthService.instance.displayName ?? '',
    );
    _emailController = TextEditingController(
      text: AuthService.instance.email ?? '',
    );
    _nameController.addListener(_onChanged);
    _currentPassword.addListener(_onChanged);
    _newPassword.addListener(_onChanged);
    _confirmPassword.addListener(_onChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  /// Coarse gate for the button: only the required name. The rest is checked
  /// on tap and reported via SnackBar.
  bool get _canSave => _nameController.text.trim().isNotEmpty;

  String? _validationError() {
    final nameError = Validators.requiredText(_nameController.text, field: 'Name');
    if (nameError != null) return nameError;

    final touchedPassword =
        _currentPassword.text.isNotEmpty ||
        _newPassword.text.isNotEmpty ||
        _confirmPassword.text.isNotEmpty;
    if (touchedPassword) {
      return Validators.requiredText(
            _currentPassword.text,
            field: 'Aktuelles Passwort',
          ) ??
          Validators.requiredText(_newPassword.text, field: 'Neues Passwort') ??
          Validators.requiredText(
            _confirmPassword.text,
            field: 'Bestätigung',
          ) ??
          Validators.match(
            _newPassword.text,
            _confirmPassword.text,
            message: 'Neue Passwörter stimmen nicht überein',
          ) ??
          Validators.passwordStrength(
            _newPassword.text,
            message: 'Neues Passwort ist zu schwach',
          );
    }
    return null;
  }

  Future<void> _handleSave() async {
    final error = _validationError();
    if (error != null) {
      _snack(error);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final auth = AuthService.instance;
      if (_nameController.text.trim() != (auth.displayName ?? '')) {
        await auth.updateDisplayName(_nameController.text);
      }
      if (_newPassword.text.isNotEmpty) {
        await auth.changePassword(
          currentPassword: _currentPassword.text,
          newPassword: _newPassword.text,
        );
      }
      _currentPassword.clear();
      _newPassword.clear();
      _confirmPassword.clear();
      if (!mounted) return;
      _snack('Profil gespeichert');
      setState(() {}); // refresh avatar / name
    } on AuthException catch (e) {
      _snack(e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (mounted) Navigator.of(context).pop(); // leave the profile screen
  }

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Abmelden',
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    auth.avatarInitial,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.bg200,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text('Name', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              _field(_nameController),
              const SizedBox(height: 24),
              Text('E-Mail', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              _field(_emailController, enabled: false),
              const SizedBox(height: 32),
              Text(
                'Passwortänderung',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Aktuelles Passwort',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              _passwordField(
                _currentPassword,
                _showCurrent,
                () => setState(() => _showCurrent = !_showCurrent),
              ),
              const SizedBox(height: 24),
              Text(
                'Neues Passwort',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              _passwordField(
                _newPassword,
                _showNew,
                () => setState(() => _showNew = !_showNew),
              ),
              const SizedBox(height: 24),
              Text(
                'Passwort bestätigen',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              _passwordField(
                _confirmPassword,
                _showConfirm,
                () => setState(() => _showConfirm = !_showConfirm),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: (_isLoading || !_canSave) ? null : _handleSave,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Speichern'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController controller, {bool enabled = true}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.bg500,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.rounded),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _passwordField(
    TextEditingController controller,
    bool visible,
    VoidCallback onToggle,
  ) {
    return TextField(
      controller: controller,
      obscureText: !visible,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.bg500,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.rounded),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            visible ? Icons.visibility : Icons.visibility_off,
            color: AppColors.bg600,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
