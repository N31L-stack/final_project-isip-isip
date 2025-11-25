// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for SystemChrome
import 'login.dart'; // Import the next screen in the flow

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  // The primary teal color from the design
  static const Color primaryTeal = Color(0xFF4DB8B8);

  @override
  Widget build(BuildContext context) {
    // Set status bar to match the background for a cohesive look
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: primaryTeal,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    
    return Scaffold(
      backgroundColor: primaryTeal,
      body: Container(
        // Added some outer padding to match the frame-like look in the image
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
        child: Container(
          // Inner container that holds the content
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
          decoration: BoxDecoration(
            color: primaryTeal, // The main color
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- Title Section ---
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // This is the main title text
                  Text(
                    'Isip-Isip: A Mobile Application for Mental Wellness',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),

              // --- Subtext Section ---
              const Text(
                'Safe, Accessible, Confidential\nCare for Every Filipino Mind',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.white, // Pure white for better contrast
                ),
              ),
              
              // --- Get Started Button Section ---
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    // Adding a slight teal shadow for depth
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to the Login screen
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_ios, size: 18, color: primaryTeal),
                    label: const Text(
                      'Get started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: primaryTeal,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0, // Handled by the container shadow
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}