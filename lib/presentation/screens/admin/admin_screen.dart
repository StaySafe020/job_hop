import 'package:flutter/material.dart';
// Uncomment below when integrating Firebase
// import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  // Simulate fetching requests (replace with Firestore in backend)
  Future<List<Map<String, dynamic>>> _fetchPendingRequests() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return [
      {
        'id': 'req1',
        'username': 'user1',
        'email': 'user1@example.com',
        'company': 'Tech Corp',
        'description': 'A tech company seeking talent.',
        'status': 'pending',
        'timestamp': DateTime.now().toString(),
      },
      {
        'id': 'req2',
        'username': 'user2',
        'email': 'user2@example.com',
        'company': 'Designify',
        'description': 'Design-focused firm.',
        'status': 'pending',
        'timestamp': DateTime.now().toString(),
      },
    ];
  }

  void _approveRequest(BuildContext context, String requestId, String username) {
    // TODO: Update request status to 'approved' and user to employer in backend
    // Example:
    // FirebaseFirestore.instance.collection('employer_requests').doc(requestId).update({'status': 'approved'});
    // FirebaseFirestore.instance.collection('users').doc(username).update({'isEmployer': true, 'isVerified': true});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Approved request $requestId for $username')));
  }

  void _rejectRequest(BuildContext context, String requestId, String username) {
    // TODO: Update request status to 'rejected' and reset user employer status in backend
    // Example:
    // FirebaseFirestore.instance.collection('employer_requests').doc(requestId).update({'status': 'rejected'});
    // FirebaseFirestore.instance.collection('users').doc(username).update({'isEmployer': false, 'isVerified': false});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Rejected request $requestId for $username')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchPendingRequests(), // Replace with StreamBuilder for real-time updates
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No pending employer requests.'));
          }
          final requests = snapshot.data!;
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return ListTile(
                title: Text('User: ${request['username']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Company: ${request['company']}'),
                    Text('Email: ${request['email']}'),
                    Text('Description: ${request['description']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () => _approveRequest(context, request['id'], request['username']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => _rejectRequest(context, request['id'], request['username']),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}