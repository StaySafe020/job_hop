import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:job_app/presentation/screens/provider/auth_provider.dart';
import 'package:job_app/presentation/screens/profiles/payment_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({super.key, required this.username});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEmployer = false;
  bool _isVerified = false;
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  final _resumeController = TextEditingController();
  final _companyDescController = TextEditingController();
  List<String> _skills = ['Flutter', 'Dart'];
  final List<Map<String, String>> _experience = [];
  final List<Map<String, String>> _education = [];
  final List<Map<String, String>> _postedJobs = [];
  final List<Map<String, String>> _recommendations = [
    {'text': 'Great team player!', 'from': 'TechCorpHR', 'id': 'rec1'},
  ];
  final String _photoUrl = '';
  final String _companyLogoUrl = '';
  StreamSubscription<DocumentSnapshot>? _requestListener;

  @override
  void initState() {
    super.initState();
    _emailController.text = '${widget.username}@example.com';
    // Fetch real user data from Firestore (example)
    _fetchUserData();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _companyController.dispose();
    _resumeController.dispose();
    _companyDescController.dispose();
    _requestListener?.cancel();
    super.dispose();
  }

  void _fetchUserData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(widget.username).get();
    if (doc.exists) {
      setState(() {
        _isEmployer = doc['isEmployer'] ?? false;
        _isVerified = doc['isVerified'] ?? false;
        _emailController.text = doc['email'] ?? '${widget.username}@example.com';
        _companyController.text = doc['company'] ?? '';
        _companyDescController.text = doc['companyDesc'] ?? '';
        _resumeController.text = doc['resume'] ?? '';
        _skills = List<String>.from(doc['skills'] ?? ['Flutter', 'Dart']);
      });
    }
  }

  void _switchToEmployer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Switch to Employer Mode'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Provide details and complete payment to verify your employer status.'),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Business Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Company Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _companyDescController,
                decoration: const InputDecoration(labelText: 'Company Description', border: OutlineInputBorder()),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              const Text('A one-time fee of \$10 is required.', style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (_emailController.text.isNotEmpty && _companyController.text.isNotEmpty && _companyDescController.text.isNotEmpty) {
                Navigator.pop(context);
                _proceedToPayment();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
              }
            },
            child: const Text('Proceed to Payment'),
          ),
        ],
      ),
    );
  }

  void _proceedToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          onPaymentComplete: (method) {
            _initiatePaymentAndSwitch(method);
          },
        ),
      ),
    );
  }

  void _initiatePaymentAndSwitch(String paymentMethod) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing payment via $paymentMethod...')));
    bool paymentSuccess = await Future.delayed(const Duration(seconds: 2), () => true); // Simulate payment
    if (paymentSuccess) {
      _requestEmployerStatus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment failed. Please try again.')));
    }
  }

  void _requestEmployerStatus() async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Employer request submitted. Awaiting approval...')));
    setState(() {
      _isEmployer = true;
      _isVerified = false;
    });

    String requestId = await FirebaseFirestore.instance.collection('employer_requests').add({
      'username': widget.username,
      'email': _emailController.text,
      'company': _companyController.text,
      'description': _companyDescController.text,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    }).then((doc) => doc.id);

    _requestListener = FirebaseFirestore.instance.collection('employer_requests').doc(requestId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        String status = snapshot.data()!['status'];
        if (status == 'approved') {
          setState(() {
            _isVerified = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Employer mode approved!')));
          _requestListener?.cancel();
        } else if (status == 'rejected') {
          setState(() {
            _isEmployer = false;
            _isVerified = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Employer request rejected.')));
          _requestListener?.cancel();
        }
      }
    });
  }

  void _switchToJobSeeker() {
    setState(() {
      _isEmployer = false;
      _isVerified = false;
      _companyController.clear();
      _companyDescController.clear();
      _postedJobs.clear();
    });
    FirebaseFirestore.instance.collection('users').doc(widget.username).update({
      'isEmployer': false,
      'isVerified': false,
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Switched to Job Seeker mode')));
  }

  void _postJob() {
    if (_isEmployer && _isVerified) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => JobPostingScreen(onJobPosted: _addPostedJob)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verify Employer mode to post jobs')));
    }
  }

  void _addPostedJob(Map<String, String> job) {
    setState(() {
      _postedJobs.add(job);
      FirebaseFirestore.instance.collection('jobs').add(job);
    });
  }

  void _editSkills() {
    final TextEditingController skillController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Skills'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Skills: ${_skills.join(', ')}'),
            const SizedBox(height: 8),
            TextField(
              controller: skillController,
              decoration: const InputDecoration(labelText: 'Add New Skill'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (skillController.text.isNotEmpty) {
                setState(() {
                  _skills.add(skillController.text);
                  FirebaseFirestore.instance.collection('users').doc(widget.username).update({'skills': _skills});
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _uploadPhoto() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo upload coming soon!')));
  }

  void _uploadCompanyLogo() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logo upload coming soon!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: _photoUrl.isEmpty
                    ? Text(widget.username[0].toUpperCase(), style: const TextStyle(fontSize: 40, color: Colors.white))
                    : Image.network(_photoUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            Center(child: ElevatedButton(onPressed: _uploadPhoto, child: const Text('Change Photo'))),
            const SizedBox(height: 24),
            const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Username: ${widget.username}', style: const TextStyle(fontSize: 16)),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 16),
            Text(
              'Role: ${_isEmployer ? 'Employer${_isVerified ? ' (Verified)' : ' (Pending)'}' : 'Job Seeker'}',
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(),
            if (!_isEmployer) ...[
              const Text('Job Seeker Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                controller: _resumeController,
                decoration: const InputDecoration(labelText: 'Resume Link (e.g., Google Drive)'),
              ),
              const SizedBox(height: 8),
              ListTile(
                title: const Text('Skills'),
                subtitle: Text(_skills.join(', ')),
                trailing: const Icon(Icons.edit),
                onTap: _editSkills,
              ),
              const SizedBox(height: 8),
              const Text('Experience (Coming Soon)', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              const Text('Education (Coming Soon)', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              const Text('Recommendations', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              _recommendations.isEmpty
                  ? const Text('No recommendations yet')
                  : Column(
                      children: _recommendations
                          .map((rec) => ListTile(
                                title: Text(rec['text']!),
                                subtitle: Text('From: ${rec['from']}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      _recommendations.remove(rec);
                                    });
                                  },
                                ),
                              ))
                          .toList(),
                    ),
            ],
            if (_isEmployer) ...[
              const Text('Employer Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Company Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _companyDescController,
                decoration: const InputDecoration(labelText: 'Company Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _uploadCompanyLogo,
                child: const Text('Upload Company Logo'),
              ),
              const SizedBox(height: 16),
              const Text('Analytics Dashboard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Text('Job Views: 150 | Applications: 20'), // Placeholder
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _postJob,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Post a Job'),
              ),
              const SizedBox(height: 16),
              const Text('Posted Jobs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              _postedJobs.isEmpty
                  ? const Text('No jobs posted yet')
                  : Column(
                      children: _postedJobs
                          .map((job) => ListTile(
                                title: Text(job['title']!),
                                subtitle: Text(job['company']!),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      _postedJobs.remove(job);
                                    });
                                  },
                                ),
                              ))
                          .toList(),
                    ),
            ],
            const Divider(),
            ElevatedButton(
              onPressed: _isEmployer ? _switchToJobSeeker : _switchToEmployer,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isEmployer ? Colors.grey : Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(_isEmployer ? 'Switch to Job Seeker' : 'Request Employer Mode'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('users').doc(widget.username).set({
                  'email': _emailController.text,
                  'isEmployer': _isEmployer,
                  'isVerified': _isVerified,
                  'company': _companyController.text,
                  'companyDesc': _companyDescController.text,
                  'resume': _resumeController.text,
                  'skills': _skills,
                }, SetOptions(merge: true));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved')));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class JobPostingScreen extends StatefulWidget {
  final Function(Map<String, String>) onJobPosted;

  const JobPostingScreen({super.key, required this.onJobPosted});

  @override
  State<JobPostingScreen> createState() => _JobPostingScreenState();
}

class _JobPostingScreenState extends State<JobPostingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _salaryController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _requirementsController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _submitJobPosting() {
    if (_formKey.currentState!.validate()) {
      final job = {
        'title': _titleController.text,
        'company': _companyController.text,
        'location': _locationController.text,
        'description': _descriptionController.text,
        'requirements': _requirementsController.text,
        'salary': _salaryController.text,
        'postedBy': 'currentUser', // Replace with real username
      };
      widget.onJobPosted(job);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Job Posted: ${job['title']}')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Job'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: _inputDecoration('Job Title'),
                  validator: (value) => value!.isEmpty ? 'Enter job title' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _companyController,
                  decoration: _inputDecoration('Company Name'),
                  validator: (value) => value!.isEmpty ? 'Enter company name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: _inputDecoration('Location'),
                  validator: (value) => value!.isEmpty ? 'Enter location' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: _inputDecoration('Description'),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Enter description' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _requirementsController,
                  decoration: _inputDecoration('Requirements'),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Enter requirements' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _salaryController,
                  decoration: _inputDecoration('Salary Range'),
                  validator: (value) => value!.isEmpty ? 'Enter salary range' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitJobPosting,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Submit Job Posting'),
                ),
              ],
            ),
          ),
        ),
      ),
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