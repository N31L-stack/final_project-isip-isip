import 'package:flutter/material.dart';

class AdminSetting extends StatefulWidget {
  const AdminSetting({super.key});
  
  // Public static credentials that login.dart can access
  static String adminEmail = "admin@isipapp.com";
  static String adminPassword = "admin123";

  @override
  State<AdminSetting> createState() => _AdminSettingState();
}

class _AdminSettingState extends State<AdminSetting> {
  // Local settings
  bool _notifications = true;
  bool _maintenanceMode = false;
  bool _autoBackup = true;
  bool _twoFactorAuth = true;
  bool _sessionTimeout = true;
  bool _loginNotifications = true;
  bool _emailNotifications = true;
  bool _appointmentAlerts = true;
  bool _systemUpdates = true;
  bool _userActivity = false;
  
  // Admin profile
  String _adminName = "Admin User";
  String _adminPhone = "+63 912 345 6789";
  
  String _notificationFrequency = "immediate";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Settings
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingItem(
                    Icons.person,
                    'Admin Profile',
                    'Manage your admin account details',
                    () => _showAdminProfileDialog(context),
                  ),
                  _buildSettingItem(
                    Icons.security,
                    'Security',
                    'Password, 2FA, and login settings',
                    () => _showSecurityDialog(context),
                  ),
                  _buildSettingItem(
                    Icons.notifications,
                    'Notifications',
                    'Configure alert preferences',
                    () => _showNotificationsDialog(context),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // System Settings
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'System Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Enable Notifications'),
                    subtitle: const Text('Receive system alerts'),
                    secondary: const Icon(Icons.notifications_active),
                    value: _notifications,
                    onChanged: (value) {
                      setState(() {
                        _notifications = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Maintenance Mode'),
                    subtitle: const Text('Restrict access to admins only'),
                    secondary: const Icon(Icons.engineering),
                    value: _maintenanceMode,
                    onChanged: (value) {
                      setState(() {
                        _maintenanceMode = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Auto Backup'),
                    subtitle: const Text('Daily automatic data backup'),
                    secondary: const Icon(Icons.backup),
                    value: _autoBackup,
                    onChanged: (value) {
                      setState(() {
                        _autoBackup = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Danger Zone
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.red),
            ),
            color: Colors.red[50],
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red),
                      const SizedBox(width: 8),
                      const Text(
                        'Danger Zone',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'These actions are irreversible. Proceed with caution.',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.pause_circle),
                          label: const Text('Pause Platform'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orange,
                            side: const BorderSide(color: Colors.orange),
                          ),
                          onPressed: () => _showPausePlatformDialog(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.delete),
                          label: const Text('Clear Data'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          onPressed: () => _showClearDataDialog(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Support
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Support',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingItem(
                    Icons.help,
                    'Help Center',
                    'Documentation and FAQs',
                    () => _showHelpCenterDialog(context),
                  ),
                  _buildSettingItem(
                    Icons.contact_support,
                    'Contact Support',
                    'Get help from our team',
                    () => _showContactSupportDialog(context),
                  ),
                  _buildSettingItem(
                    Icons.description,
                    'System Logs',
                    'View application logs',
                    () => _showSystemLogsDialog(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  // ========== DIALOG POPUPS ==========

  void _showAdminProfileDialog(BuildContext context) {
    final emailController = TextEditingController(text: AdminSetting.adminEmail);
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final nameController = TextEditingController(text: _adminName);
    final phoneController = TextEditingController(text: _adminPhone);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Admin Profile'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text(
                    'Change Password',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'New Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final newEmail = emailController.text.trim();
                  final newPassword = passwordController.text;
                  final confirmPassword = confirmPasswordController.text;
                  final newName = nameController.text.trim();
                  final newPhone = phoneController.text.trim();

                  // Validate
                  if (newEmail.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email cannot be empty')),
                    );
                    return;
                  }

                  if (newPassword.isNotEmpty && newPassword != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match')),
                    );
                    return;
                  }

                  // Update admin credentials
                  setState(() {
                    AdminSetting.adminEmail = newEmail;
                    if (newPassword.isNotEmpty) {
                      AdminSetting.adminPassword = newPassword;
                    }
                    _adminName = newName;
                    _adminPhone = newPhone;
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Save Changes'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSecurityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Security Settings'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: const Text('Two-Factor Authentication'),
                  subtitle: const Text('Require 2FA for login'),
                  value: _twoFactorAuth,
                  onChanged: (value) {
                    setState(() {
                      _twoFactorAuth = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Session Timeout'),
                  subtitle: const Text('Auto-logout after 30 minutes'),
                  value: _sessionTimeout,
                  onChanged: (value) {
                    setState(() {
                      _sessionTimeout = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Login Notifications'),
                  subtitle: const Text('Email alert for new logins'),
                  value: _loginNotifications,
                  onChanged: (value) {
                    setState(() {
                      _loginNotifications = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  'Last Login: Today at 9:30 AM',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                const Text(
                  'IP Address: 192.168.1.1',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Notification Settings'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: const Text('Email Notifications'),
                  subtitle: const Text('Receive updates via email'),
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Appointment Alerts'),
                  subtitle: const Text('New booking requests'),
                  value: _appointmentAlerts,
                  onChanged: (value) {
                    setState(() {
                      _appointmentAlerts = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('System Updates'),
                  subtitle: const Text('Platform maintenance alerts'),
                  value: _systemUpdates,
                  onChanged: (value) {
                    setState(() {
                      _systemUpdates = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('User Activity'),
                  subtitle: const Text('New registrations, etc.'),
                  value: _userActivity,
                  onChanged: (value) {
                    setState(() {
                      _userActivity = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Notification Frequency:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                RadioListTile(
                  title: const Text('Immediate'),
                  value: "immediate",
                  groupValue: _notificationFrequency,
                  onChanged: (value) {
                    setState(() {
                      _notificationFrequency = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: const Text('Daily Summary'),
                  value: "daily",
                  groupValue: _notificationFrequency,
                  onChanged: (value) {
                    setState(() {
                      _notificationFrequency = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: const Text('Weekly Summary'),
                  value: "weekly",
                  groupValue: _notificationFrequency,
                  onChanged: (value) {
                    setState(() {
                      _notificationFrequency = value.toString();
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notification settings saved'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showPausePlatformDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Pause Platform'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This will temporarily disable the platform for all users.'),
            SizedBox(height: 12),
            Text('Only admins will be able to access the system.'),
            SizedBox(height: 12),
            Text('Are you sure you want to proceed?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Platform paused successfully'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Pause Platform'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.dangerous, color: Colors.red),
            SizedBox(width: 8),
            Text('Clear All Data'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('⚠️ This action is irreversible!'),
            SizedBox(height: 12),
            Text('The following will be deleted:'),
            SizedBox(height: 8),
            Text('• All user accounts'),
            Text('• All appointment records'),
            Text('• All professional profiles'),
            Text('• All system logs'),
            SizedBox(height: 12),
            Text('This cannot be undone. Are you absolutely sure?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data has been cleared'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear All Data'),
          ),
        ],
      ),
    );
  }

  void _showHelpCenterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help Center'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Frequently Asked Questions:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Text('Q: How do I reset a user password?'),
              Text('A: Go to User Management > Select user > Reset Password', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 8),
              Text('Q: How to add a new professional?'),
              Text('A: Click the + icon in Professionals page', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 8),
              Text('Q: How to export reports?'),
              Text('A: Go to Analytics > Export button', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 8),
              Text('Q: System maintenance schedule?'),
              Text('A: Every Sunday 2:00 AM - 4:00 AM', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 16),
              Text('Need more help? Contact support below.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showContactSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: support@isipapp.com'),
            SizedBox(height: 8),
            Text('Phone: +63 2 1234 5678'),
            SizedBox(height: 8),
            Text('Hours: Mon-Fri, 9AM-6PM'),
            SizedBox(height: 16),
            Text('Emergency Contact:'),
            Text('+63 912 345 6789 (24/7)'),
            SizedBox(height: 16),
            Text('Response Time:'),
            Text('• Email: Within 24 hours'),
            Text('• Phone: Immediate during hours'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Open email client
            },
            child: const Text('Email Support'),
          ),
        ],
      ),
    );
  }

  void _showSystemLogsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('System Logs'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLogEntry('2023-12-05 09:30:00', 'System backup completed', Colors.green),
                _buildLogEntry('2023-12-05 09:15:00', 'Admin login - ${AdminSetting.adminEmail}', Colors.blue),
                _buildLogEntry('2023-12-05 08:45:00', 'New appointment booked - John Doe', Colors.blue),
                _buildLogEntry('2023-12-05 08:30:00', 'User registration - Jane Smith', Colors.blue),
                _buildLogEntry('2023-12-05 08:00:00', 'Daily maintenance check passed', Colors.green),
                _buildLogEntry('2023-12-04 23:00:00', 'Nightly backup initiated', Colors.grey),
                _buildLogEntry('2023-12-04 18:30:00', 'Security scan completed', Colors.green),
                _buildLogEntry('2023-12-04 15:45:00', 'Appointment cancelled - Robert', Colors.orange),
                _buildLogEntry('2023-12-04 14:20:00', 'New professional added - Dr. Sharma', Colors.blue),
                _buildLogEntry('2023-12-04 12:00:00', 'Database optimization', Colors.green),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logs exported successfully'),
                ),
              );
            },
            child: const Text('Export Logs'),
          ),
        ],
      ),
    );
  }

  Widget _buildLogEntry(String time, String message, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}