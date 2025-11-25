// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dashboard.dart'; // Import dashboard screen for successful registration redirect

// ----------------------------------------------------------------------
// --- REGISTRATION SCREEN ---
// ----------------------------------------------------------------------
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key}); 

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // Controllers for registration fields
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Define constants for consistency with login.dart
  static const double commonRadius = 12.0;
  static const double smallSpacing = 8.0;
  static const Color primaryColor = Color(0xFF4DB8B8); // Teal/cyan tone
  
  // Navigate to Dashboard on successful registration
  void _registerAndNavigateToDashboard() {
    // In a real app, you'd handle registration logic here (validation, API call).
    // Assuming successful registration for the demo:
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const RootScreen()),
    );
  }

  // Navigate back to LoginScreen
  void _navigateToLogin() {
    // Since RegisterScreen was pushed onto the stack, we just pop it.
    Navigator.of(context).pop();
  }

  // Helper widget to build consistent text input fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    Function(bool)? toggleObscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: smallSpacing), 
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            prefixIcon: Icon(
              icon,
              color: Colors.grey[400],
              size: 20,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                    onPressed: () {
                      if (toggleObscure != null) {
                        setState(() => toggleObscure(!obscureText));
                      }
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(commonRadius), 
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(commonRadius), 
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(commonRadius), 
              borderSide: const BorderSide(color: primaryColor, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Background gradient identical to login.dart
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5B9BD5), // Blue
              primaryColor,      // Teal
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                // Card container identical to login.dart
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(commonRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo Placeholder (Identical to login.dart)
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: primaryColor.withAlpha((255 * 0.1).round()), 
                          borderRadius: BorderRadius.circular(commonRadius), 
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person_add_alt_1, // Slightly different icon for register
                            size: 50, 
                            color: primaryColor
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      const Text(
                        'Create Account', // Changed text
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Username field
                      _buildTextField(
                        controller: _usernameController,
                        label: 'Username',
                        hint: 'Choose a username',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 20),

                      // Email field (New for registration)
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        hint: 'your.email@example.com',
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 20),

                      // Password field
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: '••••••••••',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        obscureText: _obscurePassword,
                        toggleObscure: (newValue) {
                          _obscurePassword = newValue;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password field (New for registration)
                      _buildTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        hint: '••••••••••',
                        icon: Icons.lock_open_outlined,
                        isPassword: true,
                        obscureText: _obscureConfirmPassword,
                        toggleObscure: (newValue) {
                          _obscureConfirmPassword = newValue;
                        },
                      ),
                      
                      const SizedBox(height: 12),

                      // Back to Login link (replaces Forgot Password)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: _navigateToLogin,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Back to Login',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),

                      // Register button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _registerAndNavigateToDashboard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(commonRadius),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            'Register', // Changed text
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Login prompt (replaces 'OR' and 'Login with Google')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextButton(
                            onPressed: _navigateToLogin, 
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Login', // Changed text
                              style: TextStyle(
                                fontSize: 13,
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}