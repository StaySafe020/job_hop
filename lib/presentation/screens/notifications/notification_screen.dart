import 'package:flutter/material.dart';
import 'package:job_app/presentation/screens/home/home_screen.dart';
import 'package:job_app/presentation/screens/home/job_detail_screen.dart'; // Import to reuse JobDetailsScreen

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedIndex = 1; // Default to Notifications (index 1)
  int _unreadCount = 0; // Track unread notifications

  // Sample notification data (replace with real data from an API or database)
  List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'title': 'Application Update',
      'message': 'Your application for Software Engineer at TechCorp has been viewed.',
      'time': '2 hours ago',
      'isRead': false,
    },
    {
      'id': 2,
      'title': 'New Job Posting',
      'message': 'A new UI/UX Designer role at Designify matches your profile.',
      'time': '5 hours ago',
      'isRead': true,
      'jobDetails': {
        'title': 'UI/UX Designer',
        'company': 'Designify',
        'location': 'New York',
        'description': 'Design user-friendly interfaces for mobile and web platforms.',
        'requirements': 'Proficiency in Figma, 2+ years experience',
        'salary': '\$70,000 - \$100,000',
        'postedBy': 'DesignifyTeam',
      },
    },
    {
      'id': 3,
      'title': 'Interview Scheduled',
      'message': 'Your interview with Innovate is set for Feb 25, 2025, at 10 AM.',
      'time': '1 day ago',
      'isRead': false,
    },
    {
      'id': 4,
      'title': 'Job Offer',
      'message': 'Congratulations! DataWorks has extended a job offer for Data Analyst.',
      'time': '2 days ago',
      'isRead': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _updateUnreadCount(); // Initialize unread count
    // TODO: Fetch initial notifications from backend and listen for real-time updates
    // Example: FirebaseFirestore.instance.collection('notifications').where('userId', isEqualTo: 'currentUser').snapshots().listen((snapshot) {
    //   setState(() {
    //     _notifications = snapshot.docs.map((doc) => doc.data()).toList();
    //     _updateUnreadCount();
    //   });
    // });
  }

  // Update unread notification count
  void _updateUnreadCount() {
    setState(() {
      _unreadCount = _notifications.where((n) => !(n['isRead'] as bool)).length;
    });
  }

  // Mark a notification as read/unread
  void _toggleReadStatus(int id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n['id'] == id);
      _notifications[index]['isRead'] = !_notifications[index]['isRead'];
      _updateUnreadCount();
      // TODO: Update notification status in backend
      // Example: await FirebaseFirestore.instance.collection('notifications').doc(id.toString()).update({'isRead': _notifications[index]['isRead']});
    });
  }

  // Delete a notification
  void _deleteNotification(int id) {
    setState(() {
      _notifications.removeWhere((n) => n['id'] == id);
      _updateUnreadCount();
      // TODO: Delete notification from backend
      // Example: await FirebaseFirestore.instance.collection('notifications').doc(id.toString()).delete();
    });
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
  void _addNewNotification() {
    setState(() {
      _notifications.add({
        'id': _notifications.length + 1,
        'title': 'New Message',
        'message': 'You have a new message from an employer.',
        'time': 'Just now',
        'isRead': false,
      });
      _updateUnreadCount();
    });
    // TODO: This would typically be triggered by a backend push event
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
                    color: notification['isRead'] ? Colors.white : Colors.blue[50], // Unread = light blue
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
                            notification['time'],
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          notification['isRead'] ? Icons.mark_email_read : Icons.mark_email_unread,
                          color: notification['isRead'] ? Colors.grey : Colors.blue,
                        ),
                        onPressed: () => _toggleReadStatus(notification['id']),
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

  // Helper to choose an icon based on notification type
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