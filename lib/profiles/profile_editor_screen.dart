// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileEditorScreen extends StatefulWidget {
  const ProfileEditorScreen({Key? key}) : super(key: key);

  @override
  _ProfileEditorScreenState createState() => _ProfileEditorScreenState();
}

class _ProfileEditorScreenState extends State<ProfileEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  List<String> skills = [];
  
  // Controllers
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _bioController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _skillController = TextEditingController();

  // Colors
  static const primaryColor = Color(0xFF6C63FF);
  static const backgroundColor = Color(0xFFF5F6F9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [backgroundColor, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _imageFile != null 
                            ? FileImage(_imageFile!) 
                            : null,
                        child: _imageFile == null 
                            ? Icon(Icons.person, size: 60, color: Colors.grey)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: primaryColor,
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, color: Colors.white),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                _buildTextField(_nameController, 'Full Name', Icons.person),
                _buildTextField(_titleController, 'Professional Title', Icons.work),
                _buildTextField(_emailController, 'Email', Icons.email),
                _buildTextField(_phoneController, 'Phone', Icons.phone),
                _buildTextField(_locationController, 'Location', Icons.location_on),
                _buildTextField(_bioController, 'Bio', Icons.description, maxLines: 3),
                
                SizedBox(height: 16),
                Text(
                  'Skills',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _skillController,
                        decoration: InputDecoration(
                          hintText: 'Add a skill',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: _addSkill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: skills.map((skill) => Chip(
                    label: Text(skill),
                    onDeleted: () => _removeSkill(skill),
                    // ignore: deprecated_member_use
                    backgroundColor: primaryColor.withOpacity(0.1),
                    deleteIconColor: primaryColor,
                  )).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _addSkill() {
    if (_skillController.text.isNotEmpty) {
      setState(() {
        skills.add(_skillController.text);
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      skills.remove(skill);
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement profile save logic
      // Create profile data object
      final profileData = {
        'name': _nameController.text,
        'title': _titleController.text,
        'bio': _bioController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'location': _locationController.text,
        'skills': skills,
      };
      
      // Add your backend integration here
      print('Saving profile: $profileData');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _skillController.dispose();
    super.dispose();
  }
}