import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _companyWebsiteController = TextEditingController();
  final TextEditingController _idOrRegController = TextEditingController();

  bool _isCompany = false;
  bool _isLoading = false;

  XFile? _idFrontImage;
  XFile? _idBackImage;

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    _companyWebsiteController.dispose();
    _idOrRegController.dispose();
    super.dispose();
  }

  Future<void> _pickIdImage(bool isFront) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isFront) {
          _idFrontImage = picked;
        } else {
          _idBackImage = picked;
        }
      });
    }
  }

  Future<String?> _uploadIdImage(XFile? image, String userId, String side) async {
    if (image == null) return null;
    final ref = FirebaseStorage.instance.ref().child('ids/${userId}_${side}_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putData(await image.readAsBytes());
    return await ref.getDownloadURL();
  }

  Future<void> _submitJob() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Not logged in');
      String? idFrontUrl;
      String? idBackUrl;
      if (!_isCompany) {
        idFrontUrl = await _uploadIdImage(_idFrontImage, user.uid, 'front');
        idBackUrl = await _uploadIdImage(_idBackImage, user.uid, 'back');
        if (idFrontUrl == null || idBackUrl == null) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please upload both front and back of your ID.')));
          return;
        }
      }
      await FirebaseFirestore.instance.collection('jobs').add({
        'title': _titleController.text.trim(),
        'company': _companyController.text.trim(),
        'location': _locationController.text.trim(),
        'description': _descriptionController.text.trim(),
        'contact': _contactController.text.trim(),
        'companyWebsite': _isCompany ? _companyWebsiteController.text.trim() : null,
        'idOrReg': _idOrRegController.text.trim(),
        'isCompany': _isCompany,
        'idFrontUrl': idFrontUrl,
        'idBackUrl': idBackUrl,
        'postedBy': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'verified': false, // Admin to verify
        'filled': false, // Job is open by default
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job posted! Pending verification.')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a Job')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SwitchListTile(
                title: const Text('Are you posting as a company?'),
                value: _isCompany,
                onChanged: (val) => setState(() => _isCompany = val),
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Job Title'),
                validator: (v) => v == null || v.isEmpty ? 'Enter job title' : null,
              ),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Company Name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter company name' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (v) => v == null || v.isEmpty ? 'Enter location' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Job Description'),
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? 'Enter description' : null,
              ),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Contact Email/Phone'),
                validator: (v) => v == null || v.isEmpty ? 'Enter contact info' : null,
              ),
              if (_isCompany)
                TextFormField(
                  controller: _companyWebsiteController,
                  decoration: const InputDecoration(labelText: 'Company Website'),
                  validator: (v) => v == null || v.isEmpty ? 'Enter company website' : null,
                ),
              TextFormField(
                controller: _idOrRegController,
                decoration: InputDecoration(
                  labelText: _isCompany ? 'Company Registration Number' : 'Your ID Number',
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              if (!_isCompany) ...[
                const SizedBox(height: 8),
                const Text('Upload ID Card (Front and Back)', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _idFrontImage != null
                              ? Image.file(File(_idFrontImage!.path), height: 80)
                              : const Icon(Icons.credit_card, size: 40, color: Colors.grey),
                          TextButton(
                            onPressed: () => _pickIdImage(true),
                            child: const Text('Pick Front'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          _idBackImage != null
                              ? Image.file(File(_idBackImage!.path), height: 80)
                              : const Icon(Icons.credit_card, size: 40, color: Colors.grey),
                          TextButton(
                            onPressed: () => _pickIdImage(false),
                            child: const Text('Pick Back'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitJob,
                child: _isLoading ? const CircularProgressIndicator() : const Text('Post Job'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
