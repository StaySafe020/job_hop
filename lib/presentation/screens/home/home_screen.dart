import 'package:flutter/material.dart';
import 'package:job_app/presentation/screens/home/job_detail_screen.dart';
import 'package:job_app/presentation/screens/profiles/profile_viewer_screen.dart';
import 'package:job_app/presentation/screens/profiles/employer_profile_screen.dart'; // New import
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required String username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected bottom navigation item
  final bool _isEmployer = false; // User role (fetch from backend)
  final bool _isVerified = false; // Employer verification status (fetch from backend)
  final bool _allowEmployerView = false; // Opt-in for profile visibility (fetch from backend)
  final bool _showSkills = true; // Granularity: Show skills (fetch from backend)
  final bool _showAppliedJobs = false; // Granularity: Show applied jobs (fetch from backend)
  final bool _showRecommendations = false; // Granularity: Show recommendation letters (fetch from backend)

  // Sample job data (replace with real data from an API or database)
  final List<Map<String, String>> _jobs = [
    {
      'title': 'Software Engineer',
      'company': 'Tech Corp',
      'location': 'Remote',
      'description': 'Develop and maintain scalable web applications using Flutter and Dart.',
      'requirements': '3+ years experience, Flutter, Dart, REST APIs',
      'salary': '\$80,000 - \$120,000',
      'postedBy': 'TechCorpHR',
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

  // Sample recommended jobs for carousel (with 'featured' flag for employer mode enhancement)
  final List<Map<String, String>> _recommendedJobs = [
    {
      'title': 'Senior Developer',
      'company': 'CloudNet',
      'location': 'Remote',
      'description': 'Lead development of cloud-based solutions.',
      'requirements': '5+ years experience, AWS, Node.js',
      'salary': '\$100,000 - \$140,000',
      'postedBy': 'CloudNetAdmin',
      'featured': 'true', // Priority for verified employers
    },
    {
      'title': 'Graphic Designer',
      'company': 'CreativeCo',
      'location': 'London',
      'description': 'Create stunning visuals for digital campaigns.',
      'requirements': 'Adobe Suite, 3+ years experience',
      'salary': '\$65,000 - \$95,000',
      'postedBy': 'CreativeCoHR',
      'featured': 'false',
    },
  ];

  // Sample career tip
  final String _careerTip = 'Tailor your resume for each job to stand out!';

  @override
  void initState() {
    super.initState();
    // TODO: Fetch user role, verification status, and profile visibility settings from backend
    // Example: FirebaseFirestore.instance.collection('users').doc(widget.username).get().then((doc) {
    //   _isEmployer = doc['isEmployer'] ?? false;
    //   _isVerified = doc['isVerified'] ?? false;
    //   _allowEmployerView = doc['allowEmployerView'] ?? false;
    //   _showSkills = doc['showSkills'] ?? true;
    //   _showAppliedJobs = doc['showAppliedJobs'] ?? false;
    //   _showRecommendations = doc['showRecommendations'] ?? false;
    //   _jobs = await fetchJobs();
    //   _recommendedJobs = await fetchRecommendedJobs(widget.username);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    String username = authProvider.username ?? 'User';
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false, // Remove the back arrow
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.green],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/profile', arguments: username);
                            },
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person, color: Colors.blue),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _getTimeBasedGreeting(username),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Explore New Opportunities Today!',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Jobs Viewed: 3 | Applications: 2',
                        style: const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Search Coming Soon!')),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recommended Jobs Carousel
                  const Text(
                    'Recommended for You',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _recommendedJobs.length,
                      itemBuilder: (context, index) {
                        final job = _recommendedJobs[index];
                        return GestureDetector(
                          onTap: () => _showJobDetails(context, job),
                          child: Container(
                            width: 200,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    job['title']! + (job['featured'] == 'true' ? ' (Featured)' : ''),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(job['company']!),
                                  Text(job['location']!, style: const TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quick Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildQuickAction('Search Jobs', Icons.search, () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Search Coming Soon!')),
                        );
                      }),
                      if (_isEmployer)
                        _buildQuickAction('Post a Job', Icons.add, () {
                          Navigator.pushNamed(context, '/profile', arguments: username);
                        }),
                      _buildQuickAction('Messages', Icons.message, () {
                        Navigator.pushNamed(context, '/messages', arguments: username);
                      }),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Career Tip
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb_outline, color: Colors.green),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Career Tip: $_careerTip',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Profile Snapshot (Job Seekers)
                  if (!_isEmployer)
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.person_outline, color: Colors.blue),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Profile Strength: 80%', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                const Text('Complete your profile to stand out!'),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/profile', arguments: username);
                                  },
                                  child: const Text('Edit Profile'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Talent Pool (Verified Employers Only)
                  if (_isEmployer && _isVerified) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Talent Pool',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3, // Sample candidates
                        itemBuilder: (context, index) {
                          return Container(
                            width: 150,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Candidate ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const Text('Skills: Flutter, Dart'),
                                  const SizedBox(height: 4),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileViewerScreen(userId: 'candidate${index + 1}')));
                                    },
                                    child: const Text('View'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Job List
                  const Text(
                    'Available Jobs',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final job = _jobs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      job['title']!,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              childCount: _jobs.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => _onItemTapped(index, username),
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

  // Get time-based greeting
  String _getTimeBasedGreeting(String username) {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning, $username!';
    if (hour < 17) return 'Good Afternoon, $username!';
    return 'Good Evening, $username!';
  }

  // Handle bottom navigation tap
  void _onItemTapped(int index, String username) {
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
        Navigator.pushNamed(context, '/messages', arguments: username);
        break;
      case 3:
        Navigator.pushNamed(context, '/settings', arguments: username);
        break;
    }
  }

  // Show job details screen
  void _showJobDetails(BuildContext context, Map<String, String> job) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JobDetailsScreen(job: job)),
    );
  }

  // Helper for quick action tiles
  Widget _buildQuickAction(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 1),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue, size: 30),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}