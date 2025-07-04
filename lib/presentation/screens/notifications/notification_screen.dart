import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_app/presentation/screens/home/job_detail_screen.dart'; // Import to reuse JobDetailsScreen

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedIndex = 1;
  int _unreadCount = 0;
  List<Map<String, dynamic>> _notifications = [];
  late Stream<QuerySnapshot> _notificationStream;
  String? _userId;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _userId = user?.uid;
    if (_userId != null) {
      _notificationStream = FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: _userId)
          .orderBy('createdAt', descending: true)
          .snapshots();
      _notificationStream.listen((snapshot) {
        setState(() {
          _notifications = snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();
          _updateUnreadCount();
        });
      });
    }
  }

  // Update unread notification count
  void _updateUnreadCount() {
    setState(() {
      _unreadCount = _notifications.where((n) => !(n['isRead'] as bool)).length;
    });
  }

  // Mark a notification as read/unread
  void _toggleReadStatus(String id, bool isRead) async {
    await FirebaseFirestore.instance.collection('notifications').doc(id).update({'isRead': !isRead});
  }

  // Delete a notification
  void _deleteNotification(String id) async {
    await FirebaseFirestore.instance.collection('notifications').doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification deleted')),
    );
  }

  // View notification details
  void _viewDetails(Map<String, dynamic> notification) {
    if (notification['title'] == 'New Job Posting' && notification['jobDetails'] != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JobDetailsScreen(job: notification['jobDetails']),
        ),
      ).then((_) {
        setState(() {
          notification['isRead'] = true;
          _updateUnreadCount();
          // TODO: Update notification status in backend
          // Example: await FirebaseFirestore.instance.collection('notifications').doc(notification['id'].toString()).update({'isRead': true});
        });
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(notification['title']),
          content: Text(notification['message']),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ).then((_) {
        setState(() {
          notification['isRead'] = true;
          _updateUnreadCount();
          // TODO: Update notification status in backend
          // Example: await FirebaseFirestore.instance.collection('notifications').doc(notification['id'].toString()).update({'isRead': true});
        });
      });
    }
  }

  // Handle bottom navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        // Already on Notifications
        break;
      case 2:
        Navigator.pushNamed(context, '/messages', arguments: 'User');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }

  // Simulate adding a new notification (for testing)
  void _addNewNotification() async {
    if (_userId == null) return;
    await FirebaseFirestore.instance.collection('notifications').add({
      'userId': _userId,
      'title': 'New Message',
      'message': 'You have a new message from an employer.',
      'time': 'Just now',
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light modern background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: Colors.black87),
            onPressed: () {
              setState(() {
                for (var noti in _notifications) {
                  noti['isRead'] = true;
                }
                _updateUnreadCount();
                // TODO: Update all notifications as read in backend
                // Example: await FirebaseFirestore.instance.collection('notifications').where('userId', isEqualTo: 'currentUser').get().then((snapshot) {
                //   for (var doc in snapshot.docs) {
                //     doc.reference.update({'isRead': true});
                //   }
                // });
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read')),
              );
            },
          ),
          // Temporary button to test adding a new notification
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black87),
            onPressed: _addNewNotification,
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? const Center(
              child: Text(
                'No notifications yet',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Dismissible(
                  key: Key(notification['id'].toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => _deleteNotification(notification['id']),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    color: notification['isRead'] ? Colors.white : Colors.blue[50],
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: notification['isRead'] ? Colors.grey : Colors.blue,
                        child: Icon(
                          _getIconForNotification(notification['title']),
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        notification['title'],
                        style: TextStyle(
                          fontWeight: notification['isRead'] ? FontWeight.normal : FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(notification['message']),
                          const SizedBox(height: 4),
                          Text(
                            notification['time'] ?? '',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          notification['isRead'] ? Icons.mark_email_read : Icons.mark_email_unread,
                          color: notification['isRead'] ? Colors.grey : Colors.blue,
                        ),
                        onPressed: () => _toggleReadStatus(notification['id'], notification['isRead']),
                      ),
                      onTap: () => _viewDetails(notification),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                if (_unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$_unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Notifications',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  // Helper to choose an icon based on notification title
  IconData _getIconForNotification(String title) {
    switch (title) {
      case 'Application Update':
        return Icons.work;
      case 'New Job Posting':
        return Icons.new_releases;
      case 'Interview Scheduled':
        return Icons.event;
      case 'Job Offer':
        return Icons.card_giftcard;
      default:
        return Icons.notifications;
    }
  }
}