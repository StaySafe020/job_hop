class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String userProfileImage;
  final String companyId;
  final int rating;
  final String comment;
  final DateTime timestamp;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userProfileImage,
    required this.companyId,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  // Convert model to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userProfileImage': userProfileImage,
      'companyId': companyId,
      'rating': rating,
      'comment': comment,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create model from Firestore document
  factory ReviewModel.fromMap(Map<String, dynamic> data) {
    return ReviewModel(
      id: data['id'],
      userId: data['userId'],
      userName: data['userName'],
      userProfileImage: data['userProfileImage'],
      companyId: data['companyId'],
      rating: data['rating'],
      comment: data['comment'],
      timestamp: DateTime.parse(data['timestamp']),
    );
  }
}