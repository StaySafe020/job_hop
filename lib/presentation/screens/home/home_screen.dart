import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String username; // Pass the username from login/registration

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected bottom navigation item

  // Sample job data (replace with real data from an API or database later)
  final List<Map<String, String>> _jobs = [
    {
      'title': 'Software Engineer',
      'company': 'Tech Corp',
      'location': 'Remote',
      'description': 'Develop and maintain scalable web applications using Flutter and Dart.',
      'requirements': '3+ years experience, Flutter, Dart, REST APIs',
      'salary': '\$80,000 - \$120,000',
      'postedBy': 'TechCorpHR', // Example employer username
    },
    {
      'title': 'UI/UX Designer',
      'company': 'Designify',
      'location': 'New York',
      'description': 'Design user-friendly interfaces for mobile and web platforms.',
      'requirements': 'Proficiency in Figma, 2+ years experience',
      'salary': '\$70,000 - \$100,000',
      'postedBy': 'DesignifyTeam',
    },
    {
      'title': 'Product Manager',
      'company': 'Innovate',
      'location': 'San Francisco',
      'description': 'Lead product development from ideation to launch.',
      'requirements': '5+ years in product management, agile methodology',
      'salary': '\$100,000 - \$150,000',
      'postedBy': 'InnovatePM',
    },
    {
      'title': 'Data Analyst',
      'company': 'DataWorks',
      'location': 'London',
      'description': 'Analyze data to provide actionable insights for business growth.',
      'requirements': 'SQL, Python, 2+ years experience',
      'salary': '\$60,000 - \$90,000',
      'postedBy': 'DataWorksHR',
    },
    {
      'title': 'DevOps Engineer',
      'company': 'CloudNet',
      'location': 'Remote',
      'description': 'Manage cloud infrastructure and CI/CD pipelines.',
      'requirements': 'AWS, Docker, 3+ years experience',
      'salary': '\$90,000 - \$130,000',
      'postedBy': 'CloudNetAdmin',
    },
  ];

  // Handle bottom navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        Navigator.pushNamed(context, '/notifications');
        break;
      case 2:
         Navigator.pushNamed(context, '/messages', arguments: widget.username);
        break;
      case 3:
          Navigator.pushNamed(context, '/settings', arguments: widget.username);
       
        break;
    }
  }

  // Show job details screen
  void _showJobDetails(BuildContext context, Map<String, String> job) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobDetailsScreen(job: job),
      ),
    );
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
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile', arguments: widget.username); // Navigate to profile
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
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
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {
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
                    onTap: () => _showJobDetails(context, job),
                  ),
                );
              },
            ),
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

// Job Details Screen
class JobDetailsScreen extends StatelessWidget {
  final Map<String, String> job;

  const JobDetailsScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job['title']!),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job['title']!,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Company: ${job['company']}', style: const TextStyle(fontSize: 18)),
            Text('Location: ${job['location']}', style: const TextStyle(fontSize: 18)),
            Text('Posted by: ${job['postedBy']}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text('Description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(job['description']!, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text('Requirements', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(job['requirements']!, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text('Salary: ${job['salary']}', style: const TextStyle(fontSize: 16)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                _showApplicationForm(context, job);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Apply', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  // Show application form in a dialog
  void _showApplicationForm(BuildContext context, Map<String, String> job) {
    showDialog(
      context: context,
      builder: (context) => ApplicationFormDialog(job: job),
    );
  }
}

// Application Form Dialog
class ApplicationFormDialog extends StatefulWidget {
  final Map<String, String> job;

  const ApplicationFormDialog({super.key, required this.job});

  @override
  State<ApplicationFormDialog> createState() => _ApplicationFormDialogState();
}

class _ApplicationFormDialogState extends State<ApplicationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _resumeController = TextEditingController();
  final _coverLetterController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _resumeController.dispose();
    _coverLetterController.dispose();
    super.dispose();
  }

  void _submitApplication() {
    if (_formKey.currentState!.validate()) {
      // TODO: Send application data to employer (e.g., API call)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Application submitted for ${widget.job['title']}')),
      );
      Navigator.pop(context); // Close the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text('Apply for ${widget.job['title']}'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Full Name'),
                validator: (value) => value!.isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: _inputDecoration('Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) return 'Enter your email';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _resumeController,
                decoration: _inputDecoration('Resume Link (e.g., Google Drive)'),
                validator: (value) => value!.isEmpty ? 'Provide a resume link' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _coverLetterController,
                decoration: _inputDecoration('Cover Letter'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Write a cover letter' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitApplication,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: const Text('Apply Now'),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Colors.grey[200],
    );
  }
}