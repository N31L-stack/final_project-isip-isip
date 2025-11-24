// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dashboard.dart'; // Import dashboard screen
import 'register.dart'; // <<< ADDED: Import registration screen

// ----------------------------------------------------------------------
// --- 1. LOGIN SCREEN (Initial View) ---
// ----------------------------------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key}); 

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Define constants for consistency and readability
  static const double commonRadius = 12.0;
  static const double smallSpacing = 8.0;
  static const Color primaryColor = Color(0xFF4DB8B8); // Teal/cyan tone
  
  // Navigate to RootScreen on successful login
  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const RootScreen()),
    );
  }

  // Navigate to RegisterScreen
  void _navigateToRegister() {
    // Pushes the RegisterScreen onto the stack, allowing the user to go back
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  // Dummy login function for demonstration
  void _login() {
    // In a real app, you'd check credentials here.
    // Assuming successful login for the demo:
    _navigateToDashboard();
  }

  // Dummy Google login function
  void _loginWithGoogle() {
    // In a real app, you'd handle OAuth here.
    // Assuming successful Google sign-in for the demo:
    _navigateToDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5B9BD5), // Blue
              primaryColor,// Teal
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
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
                      // Logo Placeholder
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: primaryColor.withAlpha((255 * 0.1).round()), 
                          borderRadius: BorderRadius.circular(commonRadius), 
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.self_improvement, 
                            size: 50, 
                            color: primaryColor
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Welcome text
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Username field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Username',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF666666),
                            ),
                          ),
                          const SizedBox(height: smallSpacing), 
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              hintText: 'Username',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: Colors.grey[400],
                                size: 20,
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(commonRadius), 
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(commonRadius), 
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(commonRadius), 
                                borderSide: const BorderSide(
                                  color: primaryColor,
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Password field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF666666),
                            ),
                          ),
                          const SizedBox(height: smallSpacing), 
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: '••••••••••',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.grey[400],
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(commonRadius), 
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(commonRadius), 
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(commonRadius), 
                                borderSide: const BorderSide(
                                  color: primaryColor,
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
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
                            'Login',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Divider for "or"
                      Row(
                        children: [
                          const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'OR',
                              style: TextStyle(color: Colors.grey[500], fontSize: 12),
                            ),
                          ),
                          const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Login with Google button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _loginWithGoogle,
                          icon: Icon(Icons.g_mobiledata, size: 28.0, color: Colors.black87), 
                          label: const Text(
                            'Login with Google',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF333333),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(commonRadius),
                            ),
                            side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
                            elevation: 0,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Register prompt
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextButton(
                            onPressed: _navigateToRegister, // <<< MODIFIED: Calls new navigation method
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Register',
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
    _passwordController.dispose();
    super.dispose();
  }
}

// ----------------------------------------------------------------------
// --- 2. ROOT SCREEN (5-Tab Navigation) ---
// ----------------------------------------------------------------------
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  // Screens corresponding to the 5 navigation tabs
  final List<Widget> _widgetOptions = <Widget>[
    const DashboardScreen(), // Home - imported from dashboard.dart
    const Center(child: Text('Journal Module', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Resources/Professional Help', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Community Forum', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Settings & Metrics', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex), 
      
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          // 1. Home/Dashboard
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          // 2. Journal
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Journal',
          ),
          // 3. Resources
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            activeIcon: Icon(Icons.people_alt),
            label: 'Resources',
          ),
          // 4. Forum
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Forum',
          ),
          // 5. Settings
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF4DB8B8), 
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        onTap: _onItemTapped,
      ),
    );
  }
}