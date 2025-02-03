import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../services/firestore_service.dart';

class ChatProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<ChatModel> _messages = [];

  List<ChatModel> get messages => _messages;

  // Fetch chat messages
  Future<void> fetchChatMessages(String senderId, String receiverId) async {
    _messages = await _firestoreService
        .getChatMessages(senderId, receiverId)
        .first;
    notifyListeners();
  }

  // Send a message
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    await _firestoreService.sendMessage(
      senderId: senderId,
      receiverId: receiverId,
      message: message,
    );
    await fetchChatMessages(senderId, receiverId);
  }
}