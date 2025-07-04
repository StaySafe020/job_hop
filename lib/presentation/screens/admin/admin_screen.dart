import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.deepPurple,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Pending Jobs'),
                Tab(text: 'Users'),
              ],
              labelColor: Colors.deepPurple,
              indicatorColor: Colors.deepPurple,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _PendingJobsTab(),
                  _UsersTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingJobsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('jobs').where('verified', isEqualTo: false).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No pending jobs.'));
        }
        final jobs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(job['title'] ?? ''),
                subtitle: Text('By: ${job['company'] ?? ''}\nLocation: ${job['location'] ?? ''}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      tooltip: 'Approve',
                      onPressed: () async {
                        await job.reference.update({'verified': true});
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job approved.')));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete',
                      onPressed: () async {
                        await job.reference.delete();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job deleted.')));
                      },
                    ),
                  ],
                ),
                onTap: () => _showJobDetailsDialog(context, job),
              ),
            );
          },
        );
      },
    );
  }

  void _showJobDetailsDialog(BuildContext context, QueryDocumentSnapshot job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(job['title'] ?? ''),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Company: ${job['company'] ?? ''}'),
              Text('Location: ${job['location'] ?? ''}'),
              Text('Description: ${job['description'] ?? ''}'),
              Text('Contact: ${job['contact'] ?? ''}'),
              if (job['isCompany'] == true)
                Text('Company Website: ${job['companyWebsite'] ?? ''}'),
              Text('ID/Reg: ${job['idOrReg'] ?? ''}'),
              Text('Posted By: ${job['postedBy'] ?? ''}'),
              Text('Created: ${job['createdAt'] != null ? job['createdAt'].toDate().toString() : 'N/A'}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No users found.'));
        }
        final users = snapshot.data!.docs;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(user['name'] ?? user['email'] ?? 'Unknown'),
                subtitle: Text('Email: ${user['email'] ?? ''}\nID: ${user.id}'),
                trailing: Icon(user['isEmployer'] == true ? Icons.business : Icons.person),
                onTap: () => _showUserDetailsDialog(context, user),
              ),
            );
          },
        );
      },
    );
  }

  void _showUserDetailsDialog(BuildContext context, QueryDocumentSnapshot user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user['name'] ?? user['email'] ?? 'User Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: ${user['email'] ?? ''}'),
              Text('ID: ${user.id}'),
              if (user['isEmployer'] == true) Text('Employer'),
              if (user['resume'] != null) Text('Resume: ${user['resume']}'),
              if (user['skills'] != null) Text('Skills: ${user['skills']}'),
              if (user['experience'] != null) Text('Experience: ${user['experience']}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}