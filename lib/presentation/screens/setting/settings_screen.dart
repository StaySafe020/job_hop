import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final String username;

  const SettingsScreen({super.key, required this.username});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 3;
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _isDarkMode = false;
  String _selectedLanguage = 'English';
  String _jobLocation = 'Anywhere';
  bool _profileVisible = true;
  bool _allowEmployerView = false;
  bool _showSkills = true;
  bool _showAppliedJobs = false;
  bool _showRecommendations = false;
  List<String> _jobTypes = ['Full-Time'];
  final List<String> _availableJobTypes = ['Full-Time', 'Part-Time', 'Contract', 'Remote'];

  @override
  void initState() {
    super.initState();
    // TODO: Fetch initial settings from backend
  }

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
        break;
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
              // TODO: Clear user session in backend
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password change coming soon!')));
    // TODO: Implement password change with backend
  }

  void _deleteAccountData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account Data'),
        content: const Text('Are you sure you want to delete all your data? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data deletion coming soon!')));
              // TODO: Delete user data from backend
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _editJobPreferences() {
    showDialog(
      context: context,
      builder: (context) {
        List<String> tempJobTypes = List.from(_jobTypes);
        final locationController = TextEditingController(text: _jobLocation);
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Job Preferences'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Preferred Job Location', border: OutlineInputBorder()),
                    controller: locationController,
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
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _jobTypes = tempJobTypes;
                    _jobLocation = locationController.text;
                    // TODO: Save job preferences to backend
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job preferences updated')));
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
      // TODO: Save theme preference to backend
    });
  }

  void _switchLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
      // TODO: Save language preference to backend
    });
  }

  void _openFAQ() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const FAQScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text('Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Edit Profile'),
              onTap: () => Navigator.pushNamed(context, '/profile', arguments: widget.username),
            ),
            ListTile(leading: const Icon(Icons.lock), title: const Text('Change Password'), onTap: _changePassword),
            ListTile(leading: const Icon(Icons.logout), title: const Text('Logout'), onTap: _logout),
            const Divider(),

            const Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SwitchListTile(
              secondary: const Icon(Icons.notifications),
              title: const Text('Push Notifications'),
              value: _pushNotifications,
              onChanged: (value) {
                setState(() {
                  _pushNotifications = value;
                  // TODO: Save push notification preference to backend
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
                  // TODO: Save email notification preference to backend
                });
              },
            ),
            const Divider(),

            const Text('App Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode),
              title: const Text('Dark Mode'),
              value: _isDarkMode,
              onChanged: _toggleTheme,
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              subtitle: Text(_selectedLanguage),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Select Language'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('English'),
                          onTap: () {
                            _switchLanguage('English');
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('French'),
                          onTap: () {
                            _switchLanguage('French');
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Divider(),

            const Text('Privacy & Security', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SwitchListTile(
              secondary: const Icon(Icons.visibility),
              title: const Text('Profile Visible to Employers'),
              value: _profileVisible,
              onChanged: (value) {
                setState(() {
                  _profileVisible = value;
                  // TODO: Save profile visibility to backend
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Allow Employers to View My Profile'),
              trailing: Switch(
                value: _allowEmployerView,
                onChanged: (value) {
                  setState(() {
                    _allowEmployerView = value;
                    if (!value) {
                      _showSkills = true;
                      _showAppliedJobs = false;
                      _showRecommendations = false;
                    }
                    // TODO: Save employer view permission to backend
                  });
                  if (value) {
                    _showEmployerViewOptions();
                  }
                },
              ),
            ),
            if (_allowEmployerView) ...[
              CheckboxListTile(
                title: const Text('Show Skills'),
                value: _showSkills,
                onChanged: (value) {
                  setState(() {
                    _showSkills = value!;
                    // TODO: Save granularity settings to backend
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Show Applied Jobs'),
                value: _showAppliedJobs,
                onChanged: (value) {
                  setState(() {
                    _showAppliedJobs = value!;
                    // TODO: Save granularity settings to backend
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Show Recommendation Letters'),
                value: _showRecommendations,
                onChanged: (value) {
                  setState(() {
                    _showRecommendations = value!;
                    // TODO: Save granularity settings to backend
                  });
                },
              ),
            ],
            ListTile(leading: const Icon(Icons.delete_forever), title: const Text('Delete Account Data'), onTap: _deleteAccountData),
            const Divider(),

            const Text('Help & Support', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListTile(leading: const Icon(Icons.help), title: const Text('FAQ'), onTap: _openFAQ),
            ListTile(
              leading: const Icon(Icons.support),
              title: const Text('Contact Support'),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Support Coming Soon!'))),
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
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Application History Coming Soon!'))),
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
      ),
    );
  }

  void _showEmployerViewOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile Visibility Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Show Skills'),
              value: _showSkills,
              onChanged: (value) => setState(() => _showSkills = value!),
            ),
            CheckboxListTile(
              title: const Text('Show Applied Jobs'),
              value: _showAppliedJobs,
              onChanged: (value) => setState(() => _showAppliedJobs = value!),
            ),
            CheckboxListTile(
              title: const Text('Show Recommendation Letters'),
              value: _showRecommendations,
              onChanged: (value) => setState(() => _showRecommendations = value!),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Save granularity settings to backend
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// FAQ Screen (unchanged)
class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ'), backgroundColor: Colors.blue, foregroundColor: Colors.white),
      body: const Center(child: Text('FAQ Coming Soon!')),
    );
  }
}