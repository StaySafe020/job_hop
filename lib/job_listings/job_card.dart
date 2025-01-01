import 'package:flutter/material.dart';
import './job.dart';

class JobCard extends StatelessWidget {
  final Job job;
  
  const JobCard({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(job.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.company),
            Text(job.location),
            Text(job.salary),
          ],
        ),
      ),
    );
  }
}