import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// --- 1. APPLICATION SETUP & THEME ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Isip-Isip App',
      theme: ThemeData(
        // Defining the primary calm colors
        primaryColor: const Color(0xFF4DB8B8), // Teal/cyan tone (Primary)
        hintColor: const Color(0xFF5B9BD5),    // Main blue tone
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto', 
        useMaterial3: true,
      ),
      // Start with the Login Screen
      home: const LoginScreen(),
    );
  }
}

// ----------------------------------------------------------------------
// --- 2. LOGIN SCREEN (Initial View) ---
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
  
  // --- UPDATED: Navigate to RootScreen on successful login ---
  void _navigateToDashboard() {
    // Navigator.pushReplacement is used to replace the current route (Login)
    // with the new route (RootScreen/Dashboard), preventing the user from
    // navigating back to the login screen using the back button.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const RootScreen()),
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
                              decoration: TextDecoration.underline, // Added underline for clarity
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login, // Triggers navigation
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
                          onPressed: _loginWithGoogle, // Triggers navigation
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
// --- 3. ROOT SCREEN (5-Tab Navigation) ---
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
    const DashboardScreen(), // Home
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
        // Uses the primary color defined in MyApp's theme
        selectedItemColor: Theme.of(context).primaryColor, 
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        onTap: _onItemTapped,
      ),
    );
  }
}

// ----------------------------------------------------------------------
// --- 4. DASHBOARD SCREEN (Home View) ---
// ----------------------------------------------------------------------
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Defining the specific gradient colors from the image
  static const Color startColor = Color(0xFFC8E6F0); // Light blue
  static const Color endColor = Color(0xFFE8F6D6);   // Light green/yellow

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [startColor, endColor],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  
                  // Mood Check-in Question
                  const Text(
                    'How are you feeling today?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Mood Selection Icons
                  const _MoodSelectionRow(),
                  const SizedBox(height: 20),

                  // Encouragement Text
                  const Text(
                    "You're doing great!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 80),

                  // Action Buttons Row (Journal, Meditations, Professional Help)
                  const _ActionButtonsRow(),
                  const SizedBox(height: 80),

                  // Daily Insight Card
                  const _DailyInsightCard(text: "Daily Insight: \"The only way out is through.\""),
                  const SizedBox(height: 20),
                  
                  // Placeholder for additional content to show scrollability
                  const Text(
                    "Scroll down for Personalized Metrics and Discovery Content.", 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14, 
                      color: Color(0xFF777777), 
                      fontStyle: FontStyle.italic
                    )
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// --- 5. DASHBOARD SUB-WIDGETS ---
// ----------------------------------------------------------------------

class _MoodSelectionRow extends StatelessWidget {
  const _MoodSelectionRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Happy (Green)
        _MoodButton(Icons.sentiment_satisfied_alt, const Color(0xFF90EE90), true), 
        // Neutral (Black line)
        _MoodButton(Icons.remove, Colors.grey.shade400, false), 
        // Anxious (Yellow)
        _MoodButton(Icons.remove, Colors.yellow.shade600, false),
        // Sad (Light Blue)
        _MoodButton(Icons.sentiment_dissatisfied, const Color(0xFFADD8E6), false),
        // Very Sad/Crisis (Darker Blue)
        _MoodButton(Icons.sentiment_very_dissatisfied, const Color(0xFF4682B4), false),
      ],
    );
  }
}

class _MoodButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isSmiling;

  const _MoodButton(this.icon, this.color, this.isSmiling);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Log mood action
      },
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.5),
          border: Border.all(color: color, width: 2),
        ),
        child: Center(
          child: Icon(
            isSmiling ? Icons.sentiment_satisfied_alt : icon,
            color: color,
            size: 30,
          ),
        ),
      ),
    );
  }
}


class _ActionButtonsRow extends StatelessWidget {
  const _ActionButtonsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Journal
        _ActionButton(
          title: 'Journal',
          icon: Icons.edit_note,
          color: const Color(0xFFC0D9F6), // Light Blue
          onTap: () {
            // Use findAncestorStateOfType to access RootScreen's state and switch tab
            (context.findAncestorStateOfType<_RootScreenState>()?._onItemTapped(1));
          },
        ),
        // Meditations
        _ActionButton(
          title: 'Meditations',
          icon: Icons.self_improvement,
          color: const Color(0xFFC9F0C9), // Light Green
          onTap: () {
            // Navigate to Resources Tab (index 2)
            (context.findAncestorStateOfType<_RootScreenState>()?._onItemTapped(2));
          },
        ),
        // Professional Help (Resources Tab)
        _ActionButton(
          title: 'Professional Help',
          icon: Icons.medical_services_outlined,
          color: const Color(0xFFE0C0F8), // Light Purple
          onTap: () {
            // Navigate to Resources Tab (index 2)
            (context.findAncestorStateOfType<_RootScreenState>()?._onItemTapped(2));
          },
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        height: 120,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.black54),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyInsightCard extends StatelessWidget {
  final String text;

  const _DailyInsightCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Color(0xFF444444)),
        textAlign: TextAlign.center,
      ),
    );
  }
}