import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ConnectionService {
  Future<void> checkConnection() async {
    try {
      // Check if Firebase is initialized
      await Firebase.initializeApp();

      // Attempt to add a document to the 'test' collection
      await FirebaseFirestore.instance.collection('test').add({
        'timestamp': DateTime.now(),
      });
      print('Firebase Connected successfully!');
    } catch (e) {
      print('Failed to connect to Firebase: $e');
    }
  }
}