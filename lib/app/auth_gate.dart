import 'package:filament_nexus/app/navigation_screen.dart';
import 'package:filament_nexus/app/services/auth_service.dart';
import 'package:filament_nexus/features/auth/presentation/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Routes between the auth screen and the app based on the sign-in state.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

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
        return const NavigationScreen();
      },
    );
  }
}
