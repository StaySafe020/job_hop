import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final String username; // Pass username for profile-related actions

  const SettingsScreen({super.key, required this.username});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 3; // Default to Settings (index 3)
  
  // Notification Preferences
  bool _pushNotifications = true;
  bool _emailNotifications = true;

  // App Preferences
  bool _isDarkMode = false;
  String _selectedLanguage = 'English';
  String _jobLocation = 'Anywhere';

  // Privacy & Security
  bool _profileVisible = true;

  // Job Preferences
  List<String> _jobTypes = ['Full-Time']; // Default selected types
  final List<String> _availableJobTypes = ['Full-Time', 'Part-Time', 'Contract', 'Remote'];

  // Handle bottom navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home', arguments: widget.username);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/notifications');
        break;
      case 2:
         Navigator.pushNamed(context, '/messages', arguments: widget.username);
        break;
      case 3:
        // Already on Settings
        break;
    }
  }

  // Logout confirmation
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login'); // Redirect to login
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  // Change Password (placeholder)
  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password change coming soon!')),
    );
  }

  // Delete Account Data (placeholder)
  void _deleteAccountData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account Data'),
        content: const Text('Are you sure you want to delete all your data? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data deletion coming soon!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Job Preferences Dialog
  void _editJobPreferences() {
    showDialog(
      context: context,
      builder: (context) {
        List<String> tempJobTypes = List.from(_jobTypes);
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Job Preferences'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Preferred Job Location',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(text: _jobLocation),
                    onChanged: (value) {
                      _jobLocation = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Job Types', style: TextStyle(fontWeight: FontWeight.bold)),
                  ..._availableJobTypes.map((type) => CheckboxListTile(
                        title: Text(type),
                        value: tempJobTypes.contains(type),
                        onChanged: (value) {
                          setDialogState(() {
                            if (value == true) {
                              tempJobTypes.add(type);
                            } else {
                              tempJobTypes.remove(type);
                            }
                          });
                        },
                      )),
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
                  setState(() {
                    _jobTypes = tempJobTypes;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Job preferences updated')),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Account Management
          const Text('Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Edit Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/profile', arguments: widget.username);
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            onTap: _changePassword,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: _logout,
          ),
          const Divider(),

          // 2. Notification Preferences
          const Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('Push Notifications'),
            value: _pushNotifications,
            onChanged: (value) {
              setState(() {
                _pushNotifications = value;
              });
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.email),
            title: const Text('Email Notifications'),
            value: _emailNotifications,
            onChanged: (value) {
              setState(() {
                _emailNotifications = value;
              });
            },
          ),
          const Divider(),

          // 3. App Preferences
          const Text('App Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
                // TODO: Implement theme change
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Theme change coming soon!')),
                );
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(_selectedLanguage),
            onTap: () {
              // Placeholder for language selection
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Language selection coming soon!')),
              );
            },
          ),
          const Divider(),

          // 4. Privacy & Security
          const Text('Privacy & Security', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SwitchListTile(
            secondary: const Icon(Icons.visibility),
            title: const Text('Profile Visible to Employers'),
            value: _profileVisible,
            onChanged: (value) {
              setState(() {
                _profileVisible = value;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('Delete Account Data'),
            onTap: _deleteAccountData,
          ),
          const Divider(),

          // 5. Help & Support
          const Text('Help & Support', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('FAQ'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('FAQ Coming Soon!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.support),
            title: const Text('Contact Support'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Support Coming Soon!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            subtitle: const Text('Version 1.0.0'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Job Hop',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 Job Hop Team',
              );
            },
          ),
          const Divider(),

          // 6. Job-Specific Features
          const Text('Job Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Job Preferences'),
            subtitle: Text('Location: $_jobLocation, Types: ${_jobTypes.join(', ')}'),
            onTap: _editJobPreferences,
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Application History'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Application History Coming Soon!')),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}