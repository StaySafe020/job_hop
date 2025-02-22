import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String username; // Pass the username from login/registration

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected bottom navigation item

  // Sample job data (replace with real data from an API or database)
  final List<Map<String, String>> _jobs = [
    {'title': 'Software Engineer', 'company': 'Tech corp', 'location': 'Remote'},
    {'title': 'UI/UX Designer', 'company': 'Designify', 'location': 'New York'},
    {'title': 'Product Manager', 'company': 'Innovate', 'location': 'San Francisco'},
    {'title': 'Data Analyst', 'company': 'DataWorks', 'location': 'London'},
    {'title': 'DevOps Engineer', 'company': 'CloudNet', 'location': 'Remote'},
  ];

  // Handle bottom navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // TODO: Implement navigation logic for each tab
    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        // Navigate to Notifications (placeholder)
          const SnackBar(content: Text('/notifications'));
        
        break;
      case 2:
        // Navigate to Messages (placeholder)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Messages Coming Soon!')),
        );
        break;
      case 3:
        // Navigate to Settings (placeholder)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings Coming Soon!')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            // Profile icon
            GestureDetector(
              onTap: () {
                // TODO: Navigate to profile screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile Coming Soon!')),
                );
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            // Greeting with username
            Text(
              'Hi, ${widget.username}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        actions: [
          // Search icon
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              // TODO: Implement search functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search Coming Soon!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Available Jobs header
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Available Posted Jobs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          // Scrollable job list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _jobs.length,
              itemBuilder: (context, index) {
                final job = _jobs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      job['title']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(job['company']!),
                        Text(job['location']!, style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Navigate to job details
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Viewing ${job['title']} details')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}