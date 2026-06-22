import 'package:filament_nexus/app/services/user_service.dart';
import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:filament_nexus/app/theme/app_radii.dart';
import 'package:filament_nexus/app/utils/password_hasher.dart';
import 'package:filament_nexus/app/utils/validators.dart';
import 'package:filament_nexus/features/profile/data/profile_repository.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profile = UserService().currentUser;
    _nameController = TextEditingController(text: profile.name);
    _emailController = TextEditingController(text: profile.email);
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _nameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _currentPasswordController.addListener(_onFieldChanged);
    _newPasswordController.addListener(_onFieldChanged);
    _confirmPasswordController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() => setState(() {});

  /// Coarse gate for the button: only the required base fields. Everything else
  /// (e-mail format, password rules) is checked on tap and reported via SnackBar.
  bool get _canSave =>
      _nameController.text.trim().isNotEmpty &&
      _emailController.text.trim().isNotEmpty;

  /// Returns the first validation error reason, or null when everything is
  /// valid. Used on save to show a SnackBar with the concrete reason.
  String? _validationError() {
    final base =
        Validators.requiredText(_nameController.text, field: 'Name') ??
        Validators.requiredText(_emailController.text, field: 'E-Mail') ??
        Validators.email(_emailController.text);
    if (base != null) return base;

    // A password change is all-or-nothing: as soon as any field is touched,
    // all three are required and must be consistent.
    final touchedPassword =
        _currentPasswordController.text.isNotEmpty ||
        _newPasswordController.text.isNotEmpty ||
        _confirmPasswordController.text.isNotEmpty;
    if (touchedPassword) {
      final passwordError =
          Validators.requiredText(
            _currentPasswordController.text,
            field: 'Aktuelles Passwort',
          ) ??
          Validators.requiredText(
            _newPasswordController.text,
            field: 'Neues Passwort',
          ) ??
          Validators.requiredText(
            _confirmPasswordController.text,
            field: 'Bestätigung',
          ) ??
          Validators.match(
            _newPasswordController.text,
            _confirmPasswordController.text,
            message: 'Neue Passwörter stimmen nicht überein',
          ) ??
          Validators.passwordStrength(
            _newPasswordController.text,
            message: 'Neues Passwort ist zu schwach',
          );
      if (passwordError != null) return passwordError;

      // Business check needs the stored hash, so it stays here.
      if (!PasswordHasher.verifyPassword(
        _currentPasswordController.text,
        UserService().currentUser.passwordHash,
      )) {
        return 'Aktuelles Passwort ist falsch';
      }
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFieldChanged);
    _emailController.removeListener(_onFieldChanged);
    _currentPasswordController.removeListener(_onFieldChanged);
    _newPasswordController.removeListener(_onFieldChanged);
    _confirmPasswordController.removeListener(_onFieldChanged);
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    final error = _validationError();
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    final currentProfile = UserService().currentUser;
    final newPasswordHash = _newPasswordController.text.isNotEmpty
        ? PasswordHasher.hashPassword(_newPasswordController.text)
        : currentProfile.passwordHash;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isLoading = false);

    if (!mounted) return;

    final updatedProfile = currentProfile.copyWith(
      name: _nameController.text,
      email: _emailController.text,
      passwordHash: newPasswordHash,
    );

    final repository = ProfileRepository();
    repository.updateProfile(updatedProfile);
    UserService().updateProfile(updatedProfile);

    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil erfolgreich gespeichert')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = UserService().currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
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
                    profile.avatarInitial,
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
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Max Mustermann',
                  hintStyle: TextStyle(color: AppColors.bg600),
                  filled: true,
                  fillColor: AppColors.bg500,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadii.rounded),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('E-Mail', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'max@mustermann.nexus',
                  hintStyle: TextStyle(color: AppColors.bg600),
                  filled: true,
                  fillColor: AppColors.bg500,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadii.rounded),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
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
              TextField(
                controller: _currentPasswordController,
                obscureText: !_showCurrentPassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.bg500,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadii.rounded),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showCurrentPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(
                        () => _showCurrentPassword = !_showCurrentPassword,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Neues Passwort',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _newPasswordController,
                obscureText: !_showNewPassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.bg500,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadii.rounded),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() => _showNewPassword = !_showNewPassword);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Passwort bestätigen',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_showConfirmPassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.bg500,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadii.rounded),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(
                        () => _showConfirmPassword = !_showConfirmPassword,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (_isLoading || !_canSave) ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.rounded),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.bg200,
                            ),
                          ),
                        )
                      : const Text(
                          'Speichern',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.bg200,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
