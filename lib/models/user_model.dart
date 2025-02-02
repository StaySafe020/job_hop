class UserModel {
  final String uid; // Unique ID for the user
  final String email; // User's email
  final String role; // 'job_seeker' or 'employer'
  final String? name; // User's name (optional)
  final String? profileImageUrl; // URL to the user's profile image (optional)
  final String? resumeUrl; // URL to the user's resume (for job seekers)
  final List<String>? skills; // List of skills (for job seekers)
  final String? workExperience; // Work experience (for job seekers)
  final String? education; // Education details (for job seekers)
  final String? companyName; // Company name (for employers)
  final String? companyDescription; // Company description (for employers)
  final String? companyLogoUrl; // URL to the company logo (for employers)

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.name,
    this.profileImageUrl,
    this.resumeUrl,
    this.skills,
    this.workExperience,
    this.education,
    this.companyName,
    this.companyDescription,
    this.companyLogoUrl,
  });

  // Convert model to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'resumeUrl': resumeUrl,
      'skills': skills,
      'workExperience': workExperience,
      'education': education,
      'companyName': companyName,
      'companyDescription': companyDescription,
      'companyLogoUrl': companyLogoUrl,
    };
  }

  // Create model from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '', // Ensure uid is not null
      email: data['email'] ?? '', // Ensure email is not null
      role: data['role'] ?? 'job_seeker', // Default role is 'job_seeker'
      name: data['name'],
      profileImageUrl: data['profileImageUrl'],
      resumeUrl: data['resumeUrl'],
      skills: List<String>.from(data['skills'] ?? []), // Handle null skills
      workExperience: data['workExperience'],
      education: data['education'],
      companyName: data['companyName'],
      companyDescription: data['companyDescription'],
      companyLogoUrl: data['companyLogoUrl'],
    );
  }

  // Override toString() for debugging
  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, role: $role, name: $name, profileImageUrl: $profileImageUrl, resumeUrl: $resumeUrl, skills: $skills, workExperience: $workExperience, education: $education, companyName: $companyName, companyDescription: $companyDescription, companyLogoUrl: $companyLogoUrl)';
  }
}