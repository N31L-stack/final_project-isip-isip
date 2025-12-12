// lib/settings.dart (Updated with Mood Tracking & Metrics)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_gate.dart';

const Color primaryColor = Color(0xFF4F46E5);
const Color secondaryColor = Color(0xFFC4B5FD);

class ToggleSwitch extends StatelessWidget {
  final String label;
  final bool enabled;
  final ValueChanged<bool> onToggle;

  const ToggleSwitch({
    super.key,
    required this.label,
    required this.enabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Color(0xFF374151))),
          Switch(
            value: enabled,
            onChanged: onToggle,
            activeColor: primaryColor,
          ),
        ],
      ),
    );
  }
}

class CollapsiblePanel extends StatefulWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final bool defaultOpen;

  const CollapsiblePanel({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.defaultOpen = false,
  });

  @override
  State<CollapsiblePanel> createState() => _CollapsiblePanelState();
}

class _CollapsiblePanelState extends State<CollapsiblePanel> {
  late bool _isOpen;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.defaultOpen;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isOpen = !_isOpen;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(widget.icon, color: primaryColor, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            firstChild: Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              alignment: Alignment.topLeft,
              child: widget.child,
            ),
            secondChild: const SizedBox.shrink(),
            crossFadeState: _isOpen ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          ),
        ],
      ),
    );
  }
}

// ============== MAIN SETTINGS SCREEN ==============

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser = FirebaseAuth.instance.currentUser;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();

  bool _isAuthReady = true;
  String? _userId;
  bool _isDarkMode = false;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'Calming Blue';
  String? _statusMessage;

  bool _dailyReminder = true;
  bool _journalPrompt = false;
  bool _forumAlerts = true;

  final TextEditingController _passwordController = TextEditingController();

  // Mood & Metrics Data
  List<Map<String, dynamic>> _moodHistory = [];
  Map<String, dynamic> _metrics = {};
  int _totalMoodLogs = 0;

  @override
  void initState() {
    super.initState();
    _userId = _currentUser?.uid;
    _usernameController.text = _currentUser?.displayName ?? '';
    _emailController.text = _currentUser?.email ?? '';

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          _currentUser = user;
          _userId = user?.uid;
          _isAuthReady = true;
          _usernameController.text = _currentUser?.displayName ?? '';
          _emailController.text = _currentUser?.email ?? '';
        });
        if (user != null) {
          _loadMoodData();
          _loadMetricsData();
        }
      }
    });

    if (_currentUser != null) {
      _loadMoodData();
      _loadMetricsData();
    }
  }

  Future<void> _loadMoodData() async {
    if (_userId == null) return;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId!)
          .collection('mood_logs')
          .orderBy('timestamp', descending: true)
          .limit(30)
          .get();

      setState(() {
        _moodHistory = snapshot.docs
            .map((doc) => {
                  'mood': doc['mood'],
                  'date': doc['date'],
                  'emotions': doc['emotions'] ?? [],
                  'timestamp': doc['timestamp'],
                })
            .toList();
        _totalMoodLogs = snapshot.docs.length;
      });
    } catch (e) {
      print('Error loading mood data: $e');
    }
  }

  Future<void> _loadMetricsData() async {
    if (_userId == null) return;

    try {
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      // Journal entries
      final journalSnapshot = await _firestore
          .collection('users')
          .doc(_userId!)
          .collection('journal_entries')
          .where('timestamp', isGreaterThanOrEqualTo: sevenDaysAgo)
          .get();

      // Mood logs
      final moodSnapshot = await _firestore
          .collection('users')
          .doc(_userId!)
          .collection('mood_logs')
          .where('timestamp', isGreaterThanOrEqualTo: sevenDaysAgo)
          .get();

      // Calculate streak
      int streak = 0;
      for (int i = 0; i < 7; i++) {
        final checkDate = now.subtract(Duration(days: i));
        final dateStr = '${checkDate.year}-${checkDate.month.toString().padLeft(2, '0')}-${checkDate.day.toString().padLeft(2, '0')}';

        final dayMoods = moodSnapshot.docs
            .where((doc) => doc['date'] == dateStr)
            .toList();

        if (dayMoods.isNotEmpty) {
          streak++;
        } else {
          break;
        }
      }

      setState(() {
        _metrics = {
          'journalEntries': journalSnapshot.docs.length,
          'moodLogs': moodSnapshot.docs.length,
          'streak': streak,
          'consistency':
              moodSnapshot.docs.length >= 5 ? 'High' : 'Medium',
          'displayName': _currentUser?.displayName ?? 'User',
          'lastMood': _moodHistory.isNotEmpty ? _moodHistory.first['mood'] : 'None',
        };
      });
    } catch (e) {
      print('Error loading metrics: $e');
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _deleteUserDocumentFromFirestore(String userId) async {
    try {
      final userDocRef = _firestore.collection('users').doc(userId);
      await userDocRef.delete();
      print('Successfully deleted user document: users/$userId');
    } catch (e) {
      print('Error deleting user document: $e');
    }
  }

  Future<void> _deleteUserDataFromFirestore(String userId) async {
    setState(() {
      _statusMessage = 'Deleting user data from Firestore...';
    });

    final List<String> privateCollections = [
      'journal_entries',
      'mood_logs',
      'user_settings',
    ];

    final batch = _firestore.batch();
    int documentsDeleted = 0;

    for (final collectionName in privateCollections) {
      try {
        final collectionRef = _firestore
            .collection('users')
            .doc(userId)
            .collection(collectionName);

        final snapshot = await collectionRef.get();

        for (final doc in snapshot.docs) {
          batch.delete(doc.reference);
          documentsDeleted++;
        }
      } catch (e) {
        print('Error fetching documents in $collectionName: $e');
      }
    }

    try {
      await batch.commit();
      await _deleteUserDocumentFromFirestore(userId);

      setState(() {
        _statusMessage =
            'Successfully deleted $documentsDeleted documents. Proceeding to delete account.';
      });
    } catch (e) {
      print('Firestore batch commit or main doc deletion failed: $e');
      throw Exception('Failed to delete all user data from the database.');
    }
  }

  void _handleLogout() {
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthGate()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Future<void> _deleteAccountDataAndUser({String? password}) async {
    final User? user = _currentUser;
    if (user == null) {
      setState(() => _statusMessage = 'No active user found for deletion.');
      return;
    }

    try {
      if (user.providerData.any((p) => p.providerId == 'password')) {
        if (password == null || user.email == null) {
          throw FirebaseAuthException(
              code: 'reauth-required',
              message: 'Password is required for re-authentication.');
        }

        setState(() => _statusMessage = 'Re-authenticating user...');
        final AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!, password: password);
        await user.reauthenticateWithCredential(credential);
      }

      await _deleteUserDataFromFirestore(user.uid);

      setState(() => _statusMessage = 'Deleting Firebase Auth user...');
      await user.delete();

      setState(
          () => _statusMessage = 'Account and all data PERMANENTLY DELETED.');
      _handleLogout();
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        if (e.code == 'requires-recent-login') {
          setState(() =>
              _statusMessage =
                  'Deletion failed: Security check failed. Please sign in again and retry.');
        } else if (e.code == 'wrong-password' ||
            e.code == 'reauth-required') {
          setState(() =>
              _statusMessage =
                  'Deletion failed: Incorrect password or re-authentication required.');
        } else {
          setState(() => _statusMessage = 'Deletion failed: ${e.message}');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() =>
            _statusMessage =
                'An error occurred during deletion: ${e.toString()}');
      }
    }
  }

  void _showReauthAndDeleteDialog() {
    final user = _currentUser;
    final requiresPassword =
        user?.providerData.any((p) => p.providerId == 'password') ?? false;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Account Deletion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'WARNING: This action is permanent and irreversible. All your journal entries, mood logs, and progress data will be immediately deleted.',
              ),
              if (requiresPassword) ...[
                const SizedBox(height: 16),
                const Text('To proceed, please enter your password:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _passwordController.clear();
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete Permanently',
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                final password =
                    requiresPassword ? _passwordController.text : null;
                _passwordController.clear();

                _deleteAccountDataAndUser(password: password);
              },
            ),
          ],
        );
      },
    );
  }

  void _handleDeleteAccount() {
    if (_currentUser == null) {
      setState(() => _statusMessage = 'No active user found to delete.');
      return;
    }
    _showReauthAndDeleteDialog();
  }

  void _handleExportData() {
    setState(() {
      _statusMessage =
          'Data export initiated! Your journal and logs are being prepared for download.';
    });
  }

  Future<void> _updateUsername() async {
    if (!_profileFormKey.currentState!.validate()) {
      return;
    }

    final String newUsername = _usernameController.text.trim();
    if (newUsername.isEmpty ||
        newUsername == _currentUser?.displayName) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Username is either empty or unchanged.')),
        );
      }
      return;
    }

    setState(() => _statusMessage = 'Updating username...');
    try {
      await _currentUser?.updateDisplayName(newUsername);

      await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .set({
        'displayName': newUsername,
        'lowercaseDisplayName': newUsername.toLowerCase(),
      }, SetOptions(merge: true));

      if (mounted) {
        setState(() {
          _statusMessage = 'Username updated successfully!';
          _currentUser = FirebaseAuth.instance.currentUser;
          _usernameController.text = _currentUser?.displayName ?? '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username updated successfully!')),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() =>
            _statusMessage = 'Failed to update username: ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to update username: ${e.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() =>
            _statusMessage =
                'An unexpected error occurred: ${e.toString()}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _showReauthForEmailDialog() async {
    final user = _currentUser;
    if (user == null || user.email == null) return;

    final TextEditingController reauthPasswordController =
        TextEditingController();

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Security Check'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'For security reasons, please re-enter your current password to update your email address.'),
              const SizedBox(height: 16),
              TextFormField(
                controller: reauthPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                reauthPasswordController.dispose();
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _performEmailUpdateAfterReauth(
                    reauthPasswordController.text.trim());
                reauthPasswordController.dispose();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _performEmailUpdateAfterReauth(String password) async {
    final user = _currentUser;
    if (user == null || user.email == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'No active user or email for re-authentication.')),
        );
      }
      return;
    }

    setState(() => _statusMessage = 'Re-authenticating...');
    try {
      final AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!, password: password);
      await user.reauthenticateWithCredential(credential);

      final String newEmail = _emailController.text.trim();
      await user.verifyBeforeUpdateEmail(newEmail);

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set({
        'email': newEmail,
      }, SetOptions(merge: true));

      if (mounted) {
        setState(() {
          _statusMessage =
              'Email update initiated! Please verify your new email address.';
          _currentUser = FirebaseAuth.instance.currentUser;
          _emailController.text = _currentUser?.email ?? '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Verification email sent to your new address. Please verify to complete the update.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String message = 'Failed to update email: ${e.message}';
        if (e.code == 'wrong-password') {
          message = 'Incorrect password. Please try again.';
        } else if (e.code == 'invalid-credential') {
          message = 'Invalid credentials for re-authentication.';
        } else if (e.code == 'email-already-in-use') {
          message = 'This email is already in use by another account.';
        } else if (e.code == 'invalid-email') {
          message = 'The new email address is not valid.';
        }
        setState(() => _statusMessage = message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() =>
            _statusMessage =
                'An unexpected error occurred during re-authentication: ${e.toString()}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'An unexpected error occurred: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _updateEmail() async {
    if (!_profileFormKey.currentState!.validate()) {
      return;
    }

    final String newEmail = _emailController.text.trim();
    if (newEmail.isEmpty || newEmail == _currentUser?.email) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email is either empty or unchanged.')),
        );
      }
      return;
    }

    if (_currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No active user to update email.')),
        );
      }
      return;
    }

    final bool isEmailPasswordUser = _currentUser?.providerData
            .any((p) => p.providerId == 'password') ??
        false;

    if (isEmailPasswordUser) {
      await _showReauthForEmailDialog();
    } else {
      setState(() => _statusMessage = 'Updating email...');
      try {
        await _currentUser!.verifyBeforeUpdateEmail(newEmail);

        await _firestore
            .collection('users')
            .doc(_currentUser!.uid)
            .set({
          'email': newEmail,
        }, SetOptions(merge: true));

        if (mounted) {
          setState(() {
            _statusMessage =
                'Email update initiated! Please verify your new email address.';
            _currentUser = FirebaseAuth.instance.currentUser;
            _emailController.text = _currentUser?.email ?? '';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Verification email sent. Please verify to complete the update.')),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          String message = 'Failed to update email: ${e.message}';
          if (e.code == 'requires-recent-login') {
            message =
                'Security Check: Please sign in again and retry your email update.';
          }
          setState(() => _statusMessage = message);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() =>
              _statusMessage =
                  'An unexpected error occurred: ${e.toString()}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'An unexpected error occurred: ${e.toString()}')),
          );
        }
      }
    }
  }

  Widget _buildProfileEditingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey.shade300,
          child: Icon(Icons.person, size: 40, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 10),
        Text(
          _usernameController.text.isNotEmpty
              ? _usernameController.text
              : 'No Username Set',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          _currentUser?.email ?? 'No Email',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 30),
        Form(
          key: _profileFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Username cannot be empty';
                  }
                  if (value.trim().length < 3) {
                    return 'Username must be at least 3 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _updateUsername,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Username'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const Divider(height: 40, thickness: 1),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email cannot be empty';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _updateEmail,
                  icon: const Icon(Icons.email_outlined),
                  label: const Text('Update Email'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mood Trend Overview',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFC7D2FE)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your Mood Distribution',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text(
                'Total Mood Logs: $_totalMoodLogs',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              if (_moodHistory.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: _moodHistory
                      .take(5)
                      .map((log) =>
                          Chip(label: Text(log['mood'] ?? 'Unknown')))
                      .toList(),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('Activity Correlation Summary',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildMetricRow('Journaling Entries (7 days):',
            '${_metrics['journalEntries'] ?? 0}', Colors.green),
        _buildMetricRow('Mood Logs (7 days):',
            '${_metrics['moodLogs'] ?? 0}', Colors.orange),
        _buildMetricRow('Current Streak:', '${_metrics['streak'] ?? 0} days',
            primaryColor),
        _buildMetricRow('Last Mood:', _metrics['lastMood'] ?? 'None',
            Colors.blue),
        _buildMetricRow('Consistency:', _metrics['consistency'] ?? 'Medium',
            Colors.purple),
      ],
    );
  }

  Widget _buildMetricRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF4B5563))),
          Text(value,
              style: TextStyle(color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCustomizationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Text('Notifications & Reminders',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              ToggleSwitch(
                label: 'Daily Mood Check-in Reminder',
                enabled: _dailyReminder,
                onToggle: (val) => setState(() => _dailyReminder = val),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 4.0),
                child: Text(
                  _dailyReminder ? 'Set for 8:00 PM' : 'Disabled',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              ToggleSwitch(
                label: 'Journaling Prompt Reminder',
                enabled: _journalPrompt,
                onToggle: (val) => setState(() => _journalPrompt = val),
              ),
              ToggleSwitch(
                label: 'Forum Activity Alerts',
                enabled: _forumAlerts,
                onToggle: (val) => setState(() => _forumAlerts = val),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('App Appearance',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Language',
                      style: TextStyle(
                          fontSize: 16, color: Color(0xFF374151))),
                  DropdownButton<String>(
                    value: _selectedLanguage,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() => _selectedLanguage = newValue);
                      }
                    },
                    items: <String>['English', 'Tagalog', 'Taglish']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              ToggleSwitch(
                label: 'Dark Mode',
                enabled: _isDarkMode,
                onToggle: (val) => setState(() => _isDarkMode = val),
              ),
              const SizedBox(height: 12),
              const Text('Theme Color',
                  style: TextStyle(fontSize: 16, color: Color(0xFF374151))),
              const SizedBox(height: 8),
              Row(
                children: ['Calming Blue', 'Soft Lavender', 'Warm Orange']
                    .map((colorName) {
                  Color color;
                  if (colorName == 'Calming Blue') {
                    color = primaryColor;
                  } else if (colorName == 'Soft Lavender') {
                    color = secondaryColor;
                  } else {
                    color = Colors.orange;
                  }
                  return InkWell(
                    onTap: () => setState(() => _selectedTheme = colorName),
                    child: Container(
                      width: 32,
                      height: 32,
                      margin: const EdgeInsets.only(right: 8.0),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: _selectedTheme == colorName
                            ? Border.all(
                                color: primaryColor.withOpacity(0.5),
                                width: 3)
                            : Border.all(
                                color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(_selectedTheme,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your Anonymous User ID (for support):',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              SelectableText(
                _isAuthReady && _userId != null
                    ? _userId!
                    : 'Not authenticated / Loading...',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.grey.shade800,
                  backgroundColor: Colors.grey.shade100,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Please provide this ID if you need technical assistance.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const SizedBox(height: 24),
        const Text('Data Management',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Divider(height: 8),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _handleExportData,
          icon: const Icon(Icons.download, color: primaryColor),
          label: const Text('Export My Data (Journal & Logs)',
              style: TextStyle(fontSize: 16, color: primaryColor)),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: const Color(0xFFEEF2FF),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 1,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _handleDeleteAccount,
          icon: const Icon(Icons.delete_forever, color: Colors.red),
          label: const Text('Delete Account Data (PERMANENT)',
              style: TextStyle(fontSize: 16, color: Colors.red)),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: const Color(0xFFFFECEB),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 1,
            side: const BorderSide(color: Colors.red),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Session Control',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Divider(height: 8),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _currentUser != null
              ? () async {
                  await FirebaseAuth.instance.signOut();
                  setState(() {
                    _statusMessage =
                        'Successfully logged out. Redirecting to login...';
                  });
                  _handleLogout();
                }
              : null,
          icon: const Icon(Icons.logout, color: Colors.white),
          label: const Text('Log Out',
              style: TextStyle(fontSize: 16, color: Colors.white)),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 3,
            disabledBackgroundColor: Colors.grey,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Center(
            child: Text(
              'Crucial for shared devices: Disconnects your private session.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
                top: 80, left: 16, right: 16, bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Journey (Settings & Metrics)',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937)),
                ),
                if (_statusMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(_statusMessage!,
                          style: TextStyle(
                              color: Colors.indigo.shade800)),
                    ),
                  ),
                const SizedBox(height: 16),
                CollapsiblePanel(
                  title: 'My Profile & Account',
                  icon: Icons.person,
                  defaultOpen: true,
                  child: _buildProfileEditingSection(),
                ),
                const SizedBox(height: 16),
                CollapsiblePanel(
                  title: 'Personal Metrics & Insights',
                  icon: Icons.bar_chart,
                  defaultOpen: false,
                  child: _buildMetricsSection(),
                ),
                CollapsiblePanel(
                  title: 'App Management & Customization',
                  icon: Icons.settings,
                  child: _buildCustomizationSection(),
                ),
                CollapsiblePanel(
                  title: 'Account & Data Security',
                  icon: Icons.lock,
                  child: _buildSecuritySection(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('App Version: v1.0.3 (Build 20251126)',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: const Text('Terms of Service',
                                  style: TextStyle(
                                      color: primaryColor))),
                          const Text('|',
                              style: TextStyle(color: Colors.grey)),
                          TextButton(
                              onPressed: () {},
                              child: const Text('Privacy Policy',
                                  style: TextStyle(
                                      color: primaryColor))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: primaryColor,
              padding: const EdgeInsets.only(
                  top: 35, bottom: 8, left: 16, right: 16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Your data is confidential and private. We respect the Data Privacy Act of 2012 (Philippines).',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}