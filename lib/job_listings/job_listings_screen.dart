import 'package:flutter/material.dart';
import 'job.dart';
import './job_card.dart';
import 'post_job_screen.dart';

class JobListingsScreen extends StatelessWidget {
  final List<Job> jobs = [];

  JobListingsScreen({Key? key}) : super(key: key);  // Initialize empty list, later populate with actual jobs

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Job Listings')),
      body: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) => JobCard(job: jobs[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PostJobScreen()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}