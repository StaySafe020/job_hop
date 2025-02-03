import 'package:flutter/material.dart';
import '../models/job_model.dart';
import '../services/firestore_service.dart';

class JobProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<JobModel> _jobs = [];

  List<JobModel> get jobs => _jobs;

  // Fetch all jobs
  Future<void> fetchJobs() async {
    _jobs = await _firestoreService.getJobListings().first;
    notifyListeners();
  }

  // Add a new job
  Future<void> addJob(JobModel job) async {
    await _firestoreService.saveJobListing(job);
    await fetchJobs();
  }

  // Delete a job
  Future<void> deleteJob(String jobId) async {
    await _firestoreService.deleteJobListing(jobId);
    await fetchJobs();
  }
}