import 'package:filament_nexus/app/config/app_config.dart';
import 'package:filament_nexus/app/navigation_screen.dart';
import 'package:filament_nexus/app/services/auth_service.dart';
import 'package:filament_nexus/features/auth/presentation/auth_screen.dart';
import 'package:filament_nexus/features/auth/presentation/verify_email_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Routes between auth screen, e-mail verification and the app.
///
/// Three states:
///   * signed out              → [AuthScreen]
///   * signed in, unverified   → [VerifyEmailScreen]
///   * signed in and verified  → [NavigationScreen]
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data == null) {
          return const AuthScreen();
        }

        // Read the live user: reload() updates it without a stream event.
        final auth = AuthService.instance;
        if (AppConfig.requireEmailVerification && !auth.isEmailVerified) {
          return VerifyEmailScreen(onVerified: () => setState(() {}));
        }
        return const NavigationScreen();
      },
    );
  }
}
