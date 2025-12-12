// lib/auth_gate.dart
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isip_isip/onboarding.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  static const double commonRadius = 12.0;
  static const Color primaryColor = Color(0xFF4DB8B8);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: primaryColor,
      statusBarIconBrightness: Brightness.light,
    ));

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF5B9BD5), // Blue
                    Color(0xFF4DB8B8), // Teal
                    Color(0xFF7ED9D9), // Light teal
                  ],
                ),
              ),
              child: SignInScreen(
                providers: [EmailAuthProvider()],
                headerBuilder: (context, constraints, shrinkOffset) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 60, bottom: 40),
                    child: Column(
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(Icons.self_improvement, size: 70, color: primaryColor),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Isip-Isip',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your Mental Wellness Companion',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                subtitleBuilder: (context, action) {
                  return const SizedBox.shrink();
                },
                footerBuilder: (context, action) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'By signing in, you agree to our terms and conditions.',
                      style: TextStyle(color: Color(0xFF666666), fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
                styles: const {
                  EmailFormStyle(
                    signInButtonVariant: ButtonVariant.filled,
                  ),
                },
                showAuthActionSwitch: true,
              ),
            ),
          );
        }

        return const OnboardingScreen();
      },
    );
  }
}