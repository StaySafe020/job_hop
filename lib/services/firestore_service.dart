import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/models/employer_model.dart';
import '../models/user_model.dart';
import '../models/job_model.dart';
import '../models/chat_model.dart'; // Import the ChatModel

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user profile to Firestore
  Future<void> saveUserProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  // Get user profile from Firestore
  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  // Save job listing to Firestore
  Future<void> saveJobListing(JobModel job) async {
    await _firestore.collection('jobs').doc(job.id).set(job.toMap());
  }

  // Get all job listings from Firestore
  Stream<List<JobModel>> getJobListings() {
    return _firestore.collection('jobs').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => JobModel.fromMap(doc.data())).toList();
    });
  }

  // Save chat message to Firestore
  Future<void> saveChatMessage(ChatModel chat) async {
    await _firestore.collection('chats').doc(chat.id).set(chat.toMap());
  }

  // Get chat messages between two users
  Stream<List<ChatModel>> getChatMessages(String senderId, String receiverId) {
    return _firestore
        .collection('chats')
        .where('senderId', whereIn: [senderId, receiverId])
        .where('receiverId', whereIn: [senderId, receiverId])
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ChatModel.fromMap(doc.data())).toList();
    });
  }

  getEmployerProfile(String uid) {}

  saveEmployerProfile(EmployerModel profile) {}

  saveParsedResume(String userId, Map<String, dynamic> resumeData) {}

  Future<void> saveJobApplication(Map<String, dynamic> application) async {
  await _firestore.collection('applications').doc(application['jobId']).set(application);
}

  sendMessage({required String senderId, required String receiverId, required String message}) {}

  deleteJobListing(String jobId) {}
}