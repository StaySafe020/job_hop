import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_app/presentation/screens/profiles/employer_profile_screen.dart';

class JobDetailsScreen extends StatelessWidget {
  final Map<String, String> job;

  const JobDetailsScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    // Support both Map<String, String> and Map<String, dynamic> for job
    final isFilled = job['filled'] == true || job['filled'] == 'true';
    return Scaffold(
      appBar: AppBar(
        title: Text(job['title']!),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // If the current user is the poster, allow marking as filled
          if (FirebaseAuth.instance.currentUser?.uid == job['postedBy'])
            IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              tooltip: isFilled ? 'Job already filled' : 'Mark as Filled',
              onPressed: isFilled
                  ? null
                  : () async {
                      await FirebaseFirestore.instance
                          .collection('jobs')
                          .where('title', isEqualTo: job['title'])
                          .where('postedBy', isEqualTo: job['postedBy'])
                          .limit(1)
                          .get()
                          .then((snapshot) {
                        if (snapshot.docs.isNotEmpty) {
                          snapshot.docs.first.reference.update({'filled': true});
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job marked as filled.')));
                        }
                      });
                    },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(job['title']!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                if (isFilled)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Filled', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Company: ${job['company']}', style: const TextStyle(fontSize: 18)),
            Text('Location: ${job['location']}', style: const TextStyle(fontSize: 18)),
            Text('Posted by: ${job['postedBy']}', style: const TextStyle(fontSize: 18)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EmployerProfileScreen(employerId: job['postedBy']!)),
                );
              },
              child: const Text(
                'View Employer Profile',
                style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
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
              onPressed: isFilled ? null : () => _showApplicationForm(context, job),
              style: ElevatedButton.styleFrom(
                backgroundColor: isFilled ? Colors.grey : Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(isFilled ? 'Position Filled' : 'Apply', style: const TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  void _showApplicationForm(BuildContext context, Map<String, String> job) {
    showDialog(
      context: context,
      builder: (context) => ApplicationFormDialog(job: job),
    );
  }
}

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
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Autofill if user is logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _emailController.text = user.email ?? '';
      // Optionally fetch name/resume from Firestore
      FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((doc) {
        if (doc.exists) {
          _nameController.text = doc['name'] ?? '';
          _resumeController.text = doc['resume'] ?? '';
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _resumeController.dispose();
    _coverLetterController.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      try {
        final user = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance.collection('applications').add({
          'jobId': widget.job['id'] ?? '',
          'jobTitle': widget.job['title'] ?? '',
          'applicantUid': user?.uid ?? '',
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'resume': _resumeController.text.trim(),
          'coverLetter': _coverLetterController.text.trim(),
          'status': 'submitted',
          'appliedAt': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Application submitted for ${widget.job['title']}')),
        );
        Navigator.pop(context); // Close the dialog
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit application: $e')),
        );
      } finally {
        setState(() => _isSubmitting = false);
      }
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
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
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
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitApplication,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
          child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Text('Apply Now'),
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