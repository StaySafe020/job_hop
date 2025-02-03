import 'package:flutter/foundation.dart';

enum ApplicationStatus { pending, accepted, rejected }

class ApplicationModel {
  final String id;
  final String jobId;
  final String jobSeekerId;
  final String employerId;
  final ApplicationStatus status;
  final DateTime appliedAt;
  final DateTime? updatedAt; // Track when the application was last updated

  ApplicationModel({
    required this.id,
    required this.jobId,
    required this.jobSeekerId,
    required this.employerId,
    this.status = ApplicationStatus.pending,
    required this.appliedAt,
    this.updatedAt,
  });

  // Convert model to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jobId': jobId,
      'jobSeekerId': jobSeekerId,
      'employerId': employerId,
      'status': describeEnum(status), // Store enum as string
      'appliedAt': appliedAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create model from Firestore document
  factory ApplicationModel.fromMap(Map<String, dynamic> data) {
    return ApplicationModel(
      id: data['id'],
      jobId: data['jobId'],
      jobSeekerId: data['jobSeekerId'],
      employerId: data['employerId'],
      status: _parseStatus(data['status']), // Parse string to enum
      appliedAt: DateTime.parse(data['appliedAt']),
      updatedAt: data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : null,
    );
  }

  // Helper method to parse status string to enum
  static ApplicationStatus _parseStatus(String status) {
    switch (status) {
      case 'pending':
        return ApplicationStatus.pending;
      case 'accepted':
        return ApplicationStatus.accepted;
      case 'rejected':
        return ApplicationStatus.rejected;
      default:
        throw ArgumentError('Invalid status: $status');
    }
  }

  // Override equality and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApplicationModel &&
        other.id == id &&
        other.jobId == jobId &&
        other.jobSeekerId == jobSeekerId &&
        other.employerId == employerId &&
        other.status == status &&
        other.appliedAt == appliedAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      jobId,
      jobSeekerId,
      employerId,
      status,
      appliedAt,
      updatedAt,
    );
  }
}