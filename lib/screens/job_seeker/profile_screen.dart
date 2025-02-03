import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/user_model.dart';
import '/services/firestore_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skillsController = TextEditingController();
  final _workExperienceController = TextEditingController();
  final _educationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final profile = await _firestoreService.getUserProfile(user.uid);
      if (profile != null) {
        setState(() {
          _nameController.text = profile.name ?? '';
          _skillsController.text = profile.skills?.join(', ') ?? '';
          _workExperienceController.text = profile.workExperience ?? '';
          _educationController.text = profile.education ?? '';
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final profile = UserModel(
          uid: user.uid,
          email: user.email!,
          role: 'job_seeker',
          name: _nameController.text.trim(),
          skills: _skillsController.text.trim().split(','),
          workExperience: _workExperienceController.text.trim(),
          education: _educationController.text.trim(),
        );
        await _firestoreService.saveUserProfile(profile);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile saved successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Uncomment the line below to use the simple profile screen
    // return Center(child: Text('Profile Screen'));

    // Use the complex profile screen with the form
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFieldWithIcon(
                controller: _nameController,
                labelText: 'Name',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _buildTextFieldWithIcon(
                controller: _skillsController,
                labelText: 'Skills (comma-separated)',
                icon: Icons.work,
              ),
              SizedBox(height: 20),
              _buildTextFieldWithIcon(
                controller: _workExperienceController,
                labelText: 'Work Experience',
                icon: Icons.business_center,
              ),
              SizedBox(height: 20),
              _buildTextFieldWithIcon(
                controller: _educationController,
                labelText: 'Education',
                icon: Icons.school,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
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
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
    );
  }
}