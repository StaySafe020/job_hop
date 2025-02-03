class EmployerModel {
  final String uid; // Unique ID of the employer (usually matches Firebase Auth UID)
  final String email; // Employer's email
  final String companyName; // Name of the company
  final String industry; // Industry the company operates in
  final List<String>? jobPostings; // List of job posting IDs
  final String companyDescription; // Description of the company
  final DateTime createdAt; // Timestamp when the employer profile was created
  final DateTime? updatedAt; // Timestamp when the employer profile was last updated

  EmployerModel({
    required this.uid,
    required this.email,
    required this.companyName,
    required this.industry,
    this.jobPostings,
    required this.companyDescription,
    required this.createdAt,
    this.updatedAt, required String role,
  });

  // Convert model to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'companyName': companyName,
      'industry': industry,
      'jobPostings': jobPostings,
      'companyDescription': companyDescription,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create model from Firestore document
  factory EmployerModel.fromMap(Map<String, dynamic> data) {
    return EmployerModel(
      uid: data['uid'],
      email: data['email'],
      companyName: data['companyName'],
      industry: data['industry'],
      jobPostings: data['jobPostings'] != null
          ? List<String>.from(data['jobPostings'])
          : null,
      companyDescription: data['companyDescription'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : null, role: '',
    );
  }

  // Override equality and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmployerModel &&
        other.uid == uid &&
        other.email == email &&
        other.companyName == companyName &&
        other.industry == industry &&
        other.jobPostings == jobPostings &&
        other.companyDescription == companyDescription &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      uid,
      email,
      companyName,
      industry,
      jobPostings,
      companyDescription,
      createdAt,
      updatedAt,
    );
  }
}