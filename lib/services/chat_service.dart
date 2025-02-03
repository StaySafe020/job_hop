import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send a message
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    final chat = ChatModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      timestamp: DateTime.now(),
    );

    await _firestore.collection('chats').doc(chat.id).set(chat.toMap());
  }

  // Get chat messages between two users
  Stream<List<ChatModel>> getChatMessages({
    required String senderId,
    required String receiverId,
  }) {
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
}