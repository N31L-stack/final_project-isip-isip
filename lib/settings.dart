import 'package:flutter/material.dart';

// Define primary colors
const Color primaryColor = Color(0xFF4F46E5); // Indigo-600
const Color secondaryColor = Color(0xFFC4B5FD); // Soft Lavender

// --- Utility Widgets ---

/// Custom Toggle Switch equivalent to the React component
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

/// Custom Collapsible Panel equivalent to the React component
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
          // Header Button
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
          // Collapsible Content
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

// --- Main Screen ---

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Mock State Variables (React equivalents)
  bool _isAuthReady = true;
  String? _userId = 'MOCK_USER_ID-3a2b4c5d6e7f';
  bool _isDarkMode = false;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'Calming Blue';
  String? _statusMessage;

  // Placeholder states for toggles
  bool _dailyReminder = true;
  bool _journalPrompt = false;
  bool _forumAlerts = true;

  // Helper to show custom modal dialog
  Future<void> _showConfirmationModal({
    required String title,
    required String message,
    required Function onConfirm,
    required String confirmText,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(title, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(confirmText, style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout() {
    setState(() {
      _statusMessage = 'Successfully logged out. Your data session is now closed.';
      _userId = null;
    });
    // In a real app, Firebase signOut() would happen here.
  }

  void _handleDeleteAccount() {
    _showConfirmationModal(
      title: "Confirm Account Deletion",
      message: "WARNING: This action is permanent and irreversible. All your journal entries, mood logs, and progress data will be immediately deleted.",
      onConfirm: () {
        setState(() {
          _statusMessage = 'ACCOUNT PERMANENTLY DELETED. (Simulation complete).';
        });
        _handleLogout(); // Log out after simulated deletion
      },
      confirmText: 'Yes, Delete My Data',
    );
  }

  void _handleExportData() {
    setState(() {
      _statusMessage = 'Data export initiated! Your journal and logs are being prepared for download.';
    });
  }

  // --- UI Section Builders ---

  Widget _buildMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mood Trend Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF2FF), // Indigo-50
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFC7D2FE)), // Indigo-200
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Filterable Chart Placeholder (Week/Month/Year)', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Container(
                height: 60,
                color: const Color(0xFFC7D2FE), // Indigo-200 for chart area
                alignment: Alignment.center,
                child: const Text('[Placeholder: Mood Distribution Line Chart]', style: TextStyle(fontSize: 12, color: primaryColor)),
              ),
              const SizedBox(height: 8),
              const Text('Summary: Your mood consistency improved by 15% this month.', style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('Activity Correlation Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildMetricRow('Journaling Consistency:', 'High (+20% positive days)', Colors.green),
        _buildMetricRow('Breathing Exercise Usage:', 'Medium (Stable mood)', Colors.orange),
        _buildMetricRow('Content Completion Rate:', '75% Complete', primaryColor),
        const SizedBox(height: 16),
        const Text('Emotional Keyword Analysis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Most Common Keywords (Last 90 Days):', style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 4),
              Text(
                '#Grateful (x35) • #Tired (x22) • #Challenged (x15) • #Hopeful (x11) • #Productive (x8)',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF4B5563)),
              ),
            ],
          ),
        ),
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
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCustomizationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Notifications
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
                child: Text('Notifications & Reminders', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              ToggleSwitch(
                label: 'Daily Mood Check-in Reminder',
                enabled: _dailyReminder,
                onToggle: (val) => setState(() => _dailyReminder = val),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 4.0),
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
        // App Appearance
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('App Appearance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              // Language Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Language', style: TextStyle(fontSize: 16, color: Color(0xFF374151))),
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
              // Dark Mode Toggle
              ToggleSwitch(
                label: 'Dark Mode',
                enabled: _isDarkMode,
                onToggle: (val) => setState(() => _isDarkMode = val),
              ),
              const SizedBox(height: 12),
              // Theme Color
              const Text('Theme Color', style: TextStyle(fontSize: 16, color: Color(0xFF374151))),
              const SizedBox(height: 8),
              Row(
                children: ['Calming Blue', 'Soft Lavender', 'Warm Orange'].map((colorName) {
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
                            ? Border.all(color: primaryColor.withOpacity(0.5), width: 3)
                            : Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(_selectedTheme, style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
        // User ID Display
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
              const Text('Your Anonymous User ID (for support):', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              SelectableText(
                _isAuthReady ? _userId ?? 'Not authenticated' : 'Loading...',
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
        // Passcode Lock
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Set/Change Journal Passcode/Biometric Lock', style: TextStyle(color: Color(0xFF374151))),
              Icon(Icons.keyboard_arrow_right, color: Colors.grey),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('Data Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Divider(height: 8),
        const SizedBox(height: 8),
        // Export Data Button
        ElevatedButton.icon(
          onPressed: _handleExportData,
          icon: const Icon(Icons.download, color: primaryColor),
          label: const Text('Export My Data (Journal & Logs)', style: TextStyle(fontSize: 16, color: primaryColor)),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: const Color(0xFFEEF2FF), // Indigo-100
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 1,
          ),
        ),
        const SizedBox(height: 12),
        // Delete Account Button
        ElevatedButton.icon(
          onPressed: _handleDeleteAccount,
          icon: const Icon(Icons.delete_forever, color: Colors.red),
          label: const Text('Delete Account Data (PERMANENT)', style: TextStyle(fontSize: 16, color: Colors.red)),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: const Color(0xFFFFECEB), // Red-100
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 1,
            side: const BorderSide(color: Colors.red),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Session Control', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Divider(height: 8),
        const SizedBox(height: 8),
        // Log Out Button
        ElevatedButton.icon(
          onPressed: _userId != null ? _handleLogout : null,
          icon: const Icon(Icons.logout, color: Colors.white),
          label: const Text('Log Out', style: TextStyle(fontSize: 16, color: Colors.white)),
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

  // --- Main Build Method ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 80, left: 16, right: 16, bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Journey (Settings & Metrics)',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
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
                      child: Text(_statusMessage!, style: TextStyle(color: Colors.indigo.shade800)),
                    ),
                  ),
                const SizedBox(height: 16),

                // A. Personal Metrics & Insights
                CollapsiblePanel(
                  title: 'Personal Metrics & Insights',
                  icon: Icons.bar_chart,
                  defaultOpen: true,
                  child: _buildMetricsSection(),
                ),

                // B. App Management & Customization
                CollapsiblePanel(
                  title: 'App Management & Customization',
                  icon: Icons.settings,
                  child: _buildCustomizationSection(),
                ),

                // C. Account & Data Security
                CollapsiblePanel(
                  title: 'Account & Data Security',
                  icon: Icons.lock,
                  child: _buildSecuritySection(),
                ),

                // Footer Links
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('App Version: v1.0.3 (Build 20251126)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(onPressed: () {}, child: const Text('Terms of Service', style: TextStyle(color: primaryColor))),
                          const Text('|', style: TextStyle(color: Colors.grey)),
                          TextButton(onPressed: () {}, child: const Text('Privacy Policy', style: TextStyle(color: primaryColor))),
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
              padding: const EdgeInsets.only(top: 35, bottom: 8, left: 16, right: 16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Your data is confidential and private. We respect the Data Privacy Act of 2012 (Philippines).',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
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