import 'package:flutter/foundation.dart';

enum MessageType { text, image, video }

class ChatModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final MessageType messageType;
  final DateTime timestamp;
  final bool isRead;

  ChatModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.messageType = MessageType.text,
    required this.timestamp,
    this.isRead = false,
  });

  // Convert model to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'messageType': describeEnum(messageType), // Store enum as string
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  // Create model from Firestore document
  factory ChatModel.fromMap(Map<String, dynamic> data) {
    return ChatModel(
      id: data['id'],
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      message: data['message'],
      messageType: _parseMessageType(data['messageType']), // Parse string to enum
      timestamp: DateTime.parse(data['timestamp']),
      isRead: data['isRead'] ?? false,
    );
  }

  // Helper method to parse message type string to enum
  static MessageType _parseMessageType(String type) {
    switch (type) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'video':
        return MessageType.video;
      default:
        throw ArgumentError('Invalid message type: $type');
    }
  }

  // Override equality and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatModel &&
        other.id == id &&
        other.senderId == senderId &&
        other.receiverId == receiverId &&
        other.message == message &&
        other.messageType == messageType &&
        other.timestamp == timestamp &&
        other.isRead == isRead;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      senderId,
      receiverId,
      message,
      messageType,
      timestamp,
      isRead,
    );
  }
}