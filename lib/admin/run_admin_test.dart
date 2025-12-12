// lib/run_admin_test.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// NOTE: This file must be present for Firebase to initialize.
import '../firebase_options.dart';

// 1. Import the screen you want to run
import 'admin_dashboard.dart'; 

// This function will be the entry point when you run this specific file.
void main() async {
  // CRITICAL: Ensure Flutter framework is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // CRITICAL: Initialize Firebase connection
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // 2. Run the dedicated test app
  runApp(const AdminTestRunner());
}

// Simple test app wrapper
class AdminTestRunner extends StatelessWidget {
  const AdminTestRunner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Test Runner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // 3. Set the Admin Dashboard as the home screen
      home: const AdminDashboardComplete(), 
    );
  }
}