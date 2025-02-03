import 'dart:io';
import 'dart:convert';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/job_model.dart';
import '../services/firestore_service.dart';

class AIService {
  final FirestoreService _firestoreService = FirestoreService();

  // Load a custom ML model (optional)
  Future<void> loadModel() async {
    final model = await FirebaseModelDownloader.instance.getModel(
      'your_model_name',
      FirebaseModelDownloadType.localModel,
    );
    // Use the model for predictions
  }

  // Recommend jobs based on user profile
  Future<List<JobModel>> recommendJobs(UserModel user) async {
    // Fetch all jobs from Firestore
    final jobs = await _firestoreService.getJobListings().first;

    // Simple recommendation logic (can be replaced with ML-based logic)
    final recommendedJobs = jobs.where((job) {
      final skillsMatch = user.skills?.any((skill) => job.description.contains(skill)) ?? false;
      return skillsMatch;
    }).toList();

    return recommendedJobs;
  }

  // Parse a resume file using a Python API
  Future<Map<String, dynamic>> parseResume(File resume) async {
    final uri = Uri.parse('http://your-python-api-url/parse-resume');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', resume.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      return json.decode(data);
    } else {
      throw Exception('Failed to parse resume');
    }
  }

  // Save the parsed resume data to Firestore
  Future<void> saveParsedResumeData(String userId, Map<String, dynamic> resumeData) async {
    await _firestoreService.saveParsedResume(userId, resumeData);
  }

  // Download a file from a URL and save it locally
  Future<File> downloadFile(String url, String fileName) async {
    final response = await http.get(Uri.parse(url));
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }
}