// ignore_for_file: deprecated_member_use, use_build_context_synchronously


import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:isip_isip/dashboard.dart'; // Assuming RootScreen leads to your main dashboard/content

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const Color primaryTeal = Color(0xFF4DB8B8);

  // State variables to control the onboarding flow
  bool _needsUsernameInput = false;
  // Removed: bool _needsProfilePictureInput = false;
  bool _showSummaryScreen = false;

  final TextEditingController _usernameController = TextEditingController();
  User? _currentUser;
  // Removed: File? _pickedImageFile; // No longer needed for PFP

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _usernameController.text = _currentUser?.displayName ?? ''; // Pre-fill if exists

    _determineOnboardingStep();
  }

  void _determineOnboardingStep() {
    if (_currentUser == null) {
      // User should not be here if not logged in. Should be caught by AuthGate.
      _needsUsernameInput = true; // Default if no user info yet
      return;
    }

    if (_currentUser!.displayName == null || _currentUser!.displayName!.isEmpty) {
      // User is logged in but has no username
      setState(() {
        _needsUsernameInput = true;
        _showSummaryScreen = false;
      });
    } else {
      // User has a username, move directly to summary screen (no PFP step)
      setState(() {
        _needsUsernameInput = false;
        _showSummaryScreen = true; // Show summary screen for completed users
      });
      // Optionally, for truly returning users who've completed everything,
      // you might want to navigate directly without showing the summary.
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   _navigateToRootScreen();
      // });
    }
  }

  Future<void> _updateUsername() async {
    if (_currentUser == null) return;

    final String newUsername = _usernameController.text.trim();
    if (newUsername.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a username.')),
      );
      return;
    }
    if (newUsername.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username must be at least 3 characters long.')),
      );
      return;
    }
    // Basic profanity check
    final List<String> forbiddenWords = ['fuck', 'shit', 'cunt', 'asshole']; // etc.
    if (forbiddenWords.any((word) => newUsername.toLowerCase().contains(word))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username contains inappropriate language.')),
      );
      return;
    }

    try {
      await _currentUser!.updateDisplayName(newUsername);
      await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).set({
        'displayName': newUsername,
        'lowercaseDisplayName': newUsername.toLowerCase(),
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username set successfully!')),
        );
        setState(() {
          _needsUsernameInput = false;
          _showSummaryScreen = true; // Move directly to summary
          _currentUser = FirebaseAuth.instance.currentUser; // Refresh user object
        });
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to set username: ${e.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: ${e.toString()}')),
        );
      }
    }
  }

  // Removed: _pickAndUploadImage()
  // Removed: _saveProfilePicture()
  // Removed: _skipProfilePicture()

  void _navigateToRootScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const RootScreen()), // Your main app screen
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: primaryTeal,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    if (_needsUsernameInput) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Set Your Username', style: TextStyle(color: Colors.white)),
          backgroundColor: primaryTeal,
          elevation: 0,
        ),
        backgroundColor: primaryTeal,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome! Please choose a username to get started.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'e.g., your_nickname',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.white, width: 2),
                    ),
                    labelStyle: TextStyle(color: primaryTeal.withOpacity(0.8)),
                    hintStyle: TextStyle(color: primaryTeal.withOpacity(0.6)),
                    prefixIcon: const Icon(Icons.person_outline, color: primaryTeal),
                  ),
                  style: const TextStyle(color: primaryTeal),
                  onSubmitted: (_) => _updateUsername(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateUsername,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryTeal,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Save Username & Continue',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (_showSummaryScreen) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('All Set!', style: TextStyle(color: Colors.white)),
          backgroundColor: primaryTeal,
          elevation: 0,
          automaticallyImplyLeading: false, // Hide back button on final screen
        ),
        backgroundColor: primaryTeal,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Your Profile is Ready!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: Icon(Icons.person, size: 60, color: primaryTeal.withOpacity(0.8)), // Default icon
                ),
                const SizedBox(height: 20),
                Text(
                  _currentUser?.displayName ?? 'Isip-Isip User',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  _currentUser?.email ?? '',
                  style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8)),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _navigateToRootScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryTeal,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Continue to Dashboard',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Fallback for returning users who already have a username (and no PFP step)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToRootScreen();
      });
      return const Scaffold(
        backgroundColor: primaryTeal,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white), // Show loading indicator
        ),
      );
    }
  }
}