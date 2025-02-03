import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/employer_model.dart';
import '/services/firestore_service.dart';

class EmployerProfileScreen extends StatefulWidget {
  @override
  _EmployerProfileScreenState createState() => _EmployerProfileScreenState();
}

class _EmployerProfileScreenState extends State<EmployerProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _industryController = TextEditingController();
  final _jobPostingsController = TextEditingController();
  final _companyDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEmployerProfile();
  }

  Future<void> _loadEmployerProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final profile = await _firestoreService.getEmployerProfile(user.uid);
      if (profile != null) {
        setState(() {
          _companyNameController.text = profile.companyName ?? '';
          _industryController.text = profile.industry ?? '';
          _jobPostingsController.text = profile.jobPostings?.join(', ') ?? '';
          _companyDescriptionController.text = profile.companyDescription ?? '';
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final profile = EmployerModel(
          uid: user.uid,
          email: user.email!,
          role: 'employer',
          companyName: _companyNameController.text.trim(),
          industry: _industryController.text.trim(),
          jobPostings: _jobPostingsController.text.trim().split(','),
          companyDescription: _companyDescriptionController.text.trim(), createdAt: DateTime.now(),
        );
        await _firestoreService.saveEmployerProfile(profile);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile saved successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employer Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple, // Different color for distinction
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFieldWithIcon(
                controller: _companyNameController,
                labelText: 'Company Name',
                icon: Icons.business,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your company name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _buildTextFieldWithIcon(
                controller: _industryController,
                labelText: 'Industry',
                icon: Icons.work_outline,
              ),
              SizedBox(height: 20),
              _buildTextFieldWithIcon(
                controller: _jobPostingsController,
                labelText: 'Job Postings (comma-separated)',
                icon: Icons.list_alt,
              ),
              SizedBox(height: 20),
              _buildTextFieldWithIcon(
                controller: _companyDescriptionController,
                labelText: 'Company Description',
                icon: Icons.description,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Matching app bar color
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Save Profile',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithIcon({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.deepPurple), // Matching app bar color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
    );
  }
}