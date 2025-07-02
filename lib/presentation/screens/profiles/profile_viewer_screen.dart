import 'package:flutter/material.dart';

class ProfileViewerScreen extends StatelessWidget {
  final String userId;

  const ProfileViewerScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch profile data from backend based on userId and permissions
    // Example: var profile = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    // bool allowEmployerView = profile['allowEmployerView'] ?? false;
    // bool showSkills = allowEmployerView && (profile['showSkills'] ?? false);
    // bool showAppliedJobs = allowEmployerView && (profile['showAppliedJobs'] ?? false);
    // bool showRecommendations = allowEmployerView && (profile['showRecommendations'] ?? false);
    // String name = profile['username'] ?? 'Unknown';
    // List<String> skills = showSkills ? (profile['skills'] ?? []) : [];
    // List<String> appliedJobs = showAppliedJobs ? (profile['appliedJobs'] ?? []) : [];
    // String recommendations = showRecommendations ? (profile['recommendations'] ?? '') : '';

    // Sample data for now
    const String name = 'John Doe';
    bool allowEmployerView = true;
    bool showSkills = true;
    bool showAppliedJobs = false;
    bool showRecommendations = true;
    const List<String> skills = ['Flutter', 'Dart'];
    const List<String> appliedJobs = ['Software Engineer - Tech Corp'];
    const String recommendations = 'Great team player! - Jane Smith';

    if (userId == 'candidate1') {
      allowEmployerView = true;
      showSkills = true;
      showAppliedJobs = true;
      showRecommendations = true;
    } else if (userId == 'candidate2') {
      allowEmployerView = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidate Profile'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (allowEmployerView && showSkills) ...[
              const Text('Skills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(skills.join(', ')),
              const SizedBox(height: 16),
            ],
            if (allowEmployerView && showAppliedJobs) ...[
              const Text('Applied Jobs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(appliedJobs.join(', ')),
              const SizedBox(height: 16),
            ],
            if (allowEmployerView && showRecommendations) ...[
              const Text('Recommendations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(recommendations),
              const SizedBox(height: 16),
            ],
            if (!allowEmployerView) ...[
              const Text(
                'This user has not allowed employers to view their profile.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: () => _showRecommendationForm(context, userId),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Submit Recommendation'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRecommendationForm(BuildContext context, String userId) {
    final TextEditingController recommendationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Recommendation'),
        content: TextField(
          controller: recommendationController,
          decoration: const InputDecoration(
            labelText: 'Recommendation',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (recommendationController.text.isNotEmpty) {
                // TODO: Submit recommendation to backend
                // Example: await FirebaseFirestore.instance.collection('users').doc(userId).collection('recommendations').add({
                //   'text': _recommendationController.text,
                //   'from': currentEmployerUsername, // Fetch from auth
                //   'timestamp': FieldValue.serverTimestamp(),
                // });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recommendation submitted')),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}