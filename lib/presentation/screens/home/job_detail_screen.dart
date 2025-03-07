import 'package:flutter/material.dart';
import 'package:job_app/presentation/screens/profiles/employer_profile_screen.dart';

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
            Text(job['title']!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
              onPressed: () => _showApplicationForm(context, job),
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
          onPressed: _submitApplication,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
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