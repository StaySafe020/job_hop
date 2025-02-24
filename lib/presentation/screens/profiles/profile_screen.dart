import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({super.key, required this.username});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEmployer = false; // Current role (false = Job Seeker, true = Employer)
  bool _isVerified = false; // Employer verification status
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  final _resumeController = TextEditingController();
  final _companyDescController = TextEditingController();
  List<String> _skills = ['Flutter', 'Dart']; // Example skills
  List<Map<String, String>> _experience = []; // Example experience
  List<Map<String, String>> _education = []; // Example education
  List<Map<String, String>> _postedJobs = []; // Example posted jobs
  String _photoUrl = ''; // Placeholder for profile photo

  @override
  void initState() {
    super.initState();
    _emailController.text = '${widget.username}@example.com'; // Example email
    // TODO: Fetch real user data from database/API (e.g., Firebase)
    // Example: _isEmployer = await fetchUserRole(widget.username);
    // _skills = await fetchSkills(widget.username);
    // _resumeController.text = await fetchResume(widget.username);
    // _photoUrl = await fetchProfilePhoto(widget.username);
    // if (_isEmployer) {
    //   _companyController.text = await fetchCompanyName(widget.username);
    //   _companyDescController.text = await fetchCompanyDesc(widget.username);
    //   _postedJobs = await fetchPostedJobs(widget.username);
    //   _isVerified = await fetchVerificationStatus(widget.username);
    // }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _companyController.dispose();
    _resumeController.dispose();
    _companyDescController.dispose();
    super.dispose();
  }

  // Switch to Employer with protocols including payment
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
                decoration: const InputDecoration(
                  labelText: 'Business Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _companyDescController,
                decoration: const InputDecoration(
                  labelText: 'Company Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              const Text('A one-time fee of \$10 is required to switch to Employer mode.',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
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
              if (_emailController.text.isNotEmpty &&
                  _companyController.text.isNotEmpty &&
                  _companyDescController.text.isNotEmpty) {
                Navigator.pop(context);
                _initiatePaymentAndSwitch();
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

  // Initiate payment and switch to employer mode
  void _initiatePaymentAndSwitch() async {
    // TODO: Integrate with payment gateway (e.g., Stripe, PayPal)
    // 1. Show payment UI (e.g., Stripe Checkout)
    // Example: bool paymentSuccess = await processPayment(amount: 10.00, currency: 'USD');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing payment...')),
    );

    // Simulate payment process
    bool paymentSuccess = await Future.delayed(const Duration(seconds: 2), () => true); // Placeholder

    if (paymentSuccess) {
      // TODO: Save payment confirmation to database
      // Example: await savePaymentRecord(widget.username, amount: 10.00, status: 'completed');
      _requestEmployerStatus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment failed. Please try again.')),
      );
    }
  }

  // Request employer status after payment
  void _requestEmployerStatus() async {
    // TODO: Integrate with backend for employer verification
    // 1. Send email verification link to _emailController.text
    // Example: await sendEmailVerification(_emailController.text);
    // 2. Save request to database with pending status
    // Example: await saveEmployerRequest(widget.username, _emailController.text, _companyController.text, _companyDescController.text);
    // 3. Notify admin for manual approval (e.g., via Firebase Cloud Functions)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Employer request submitted. Awaiting approval...')),
    );

    // Simulate approval delay (replace with real backend response)
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isEmployer = true;
      _isVerified = false; // Pending verification
      // TODO: Update user role in database
      // Example: await updateUserRole(widget.username, 'Employer', isVerified: false);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Switched to Employer mode (pending verification)')),
    );
  }

  // Switch back to Job Seeker
  void _switchToJobSeeker() {
    setState(() {
      _isEmployer = false;
      _isVerified = false;
      _companyController.clear();
      _companyDescController.clear();
      _postedJobs.clear();
      // TODO: Update user role in database
      // Example: await updateUserRole(widget.username, 'Job Seeker');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Switched to Job Seeker mode')),
    );
  }

  // Navigate to job posting screen
  void _postJob() {
    if (_isEmployer) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => JobPostingScreen(onJobPosted: _addPostedJob)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Switch to Employer mode to post jobs')),
      );
    }
  }

  // Add posted job to list
  void _addPostedJob(Map<String, String> job) {
    setState(() {
      _postedJobs.add(job);
      // TODO: Save job to database and sync with HomeScreen
      // Example: await saveJobToDatabase(job);
    });
  }

  // Edit skills
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (skillController.text.isNotEmpty) {
                setState(() {
                  _skills.add(skillController.text);
                  // TODO: Save updated skills to database
                  // Example: await updateSkills(widget.username, _skills);
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

  // Placeholder for photo upload
  void _uploadPhoto() {
    // TODO: Integrate with file picker and cloud storage (e.g., Firebase Storage)
    // Example: _photoUrl = await uploadProfilePhoto(widget.username);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photo upload coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous screen (Home or Settings)
          },
        ),
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: _photoUrl.isEmpty
                    ? Text(
                        widget.username[0].toUpperCase(),
                        style: const TextStyle(fontSize: 40, color: Colors.white),
                      )
                    : Image.network(_photoUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _uploadPhoto,
                child: const Text('Change Photo'),
              ),
            ),
            const SizedBox(height: 24),

            // Basic Info
            const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Username: ${widget.username}', style: const TextStyle(fontSize: 16)),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            Text('Role: ${_isEmployer ? 'Employer${_isVerified ? ' (Verified)' : ' (Pending)'}' : 'Job Seeker'}',
                style: const TextStyle(fontSize: 16)),
            const Divider(),

            // Job Seeker Section
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
              // TODO: Add form for experience (e.g., job title, company, dates)
              const SizedBox(height: 8),
              const Text('Education (Coming Soon)', style: TextStyle(fontSize: 16)),
              // TODO: Add form for education (e.g., degree, institution, dates)
            ],

            // Employer Section
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
                      children: _postedJobs.map((job) => ListTile(
                            title: Text(job['title']!),
                            subtitle: Text(job['company']!),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  _postedJobs.remove(job);
                                  // TODO: Delete job from database
                                  // Example: await deleteJobFromDatabase(job['id']);
                                });
                              },
                            ),
                          )).toList(),
                    ),
            ],

            // Actions
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
                // TODO: Save profile changes to database
                // Example: await saveProfile(
                //   username: widget.username,
                //   email: _emailController.text,
                //   resume: _resumeController.text,
                //   skills: _skills,
                //   company: _companyController.text,
                //   companyDesc: _companyDescController.text,
                // );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile saved')),
                );
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

// Job Posting Screen with callback (unchanged)
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
      // TODO: Save job to database and sync with HomeScreen
      // Example: String jobId = await saveJobToDatabase(job);
      // job['id'] = jobId;
      widget.onJobPosted(job);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Job Posted: ${job['title']}')),
      );
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