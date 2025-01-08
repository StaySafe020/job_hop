import 'package:cloud_firestore/cloud_firestore.dart';
import '../notifications/notification_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<void> markAllNotificationsAsRead() async {
    // Implement the logic to mark all notifications as read in Firebase

    // Example implementation:

    final notifications = await getNotifications().first;

    for (var notification in notifications) {

      if (!notification.isRead) {

        await markNotificationAsRead(notification.id);

      }

    }

  }

  Stream<List<NotificationModel>> getNotifications() {

    // TODO: Implement the actual Firebase query

    return Stream.value([]); // Temporary empty stream

  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await _db.collection('notifications').doc(notificationId).update({'isRead': true});
  }


  // Users Collection
  Future<void> createUser(String uid, Map<String, dynamic> data) {
    return _db.collection('users').doc(uid).set(data);
  }

  Future<DocumentSnapshot> getUser(String uid) {
    return _db.collection('users').doc(uid).get();
  }

  // Jobs Collection
  Future<void> createJob(Map<String, dynamic> data) {
    return _db.collection('jobs').add(data);
  }

  Stream<QuerySnapshot> getJobs() {
    return _db.collection('jobs').snapshots();
  }

  // Applications Collection
  Future<void> submitApplication(Map<String, dynamic> data) {
    return _db.collection('applications').add(data);
  }
}