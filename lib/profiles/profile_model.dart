class Education {
  final String degree;
  final String institution;
  final String startDate;
  final String endDate;
  final double gpa;

  Education({
    required this.degree,
    required this.institution,
    required this.startDate,
    required this.endDate,
    this.gpa = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'degree': degree,
    'institution': institution,
    'startDate': startDate,
    'endDate': endDate,
    'gpa': gpa,
  };

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    degree: json['degree'] ?? '',
    institution: json['institution'] ?? '',
    startDate: json['startDate'] ?? '',
    endDate: json['endDate'] ?? '',
    gpa: json['gpa']?.toDouble() ?? 0.0,
  );
}

class Experience {
  final String title;
  final String company;
  final String location;
  final String startDate;
  final String endDate;
  final List<String> responsibilities;

  Experience({
    required this.title,
    required this.company,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.responsibilities,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'company': company,
    'location': location,
    'startDate': startDate,
    'endDate': endDate,
    'responsibilities': responsibilities,
  };

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    title: json['title'] ?? '',
    company: json['company'] ?? '',
    location: json['location'] ?? '',
    startDate: json['startDate'] ?? '',
    endDate: json['endDate'] ?? '',
    responsibilities: List<String>.from(json['responsibilities'] ?? []),
  );
}

class Profile {
  final String id;
  final String userId;
  final String fullName;
  final String email;
  final String phone;
  final String location;
  final String title;
  final String bio;
  final String avatarUrl;
  final List<String> skills;
  final List<Education> education;
  final List<Experience> experience;
  final DateTime createdAt;
  final DateTime updatedAt;

  Profile({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.location,
    required this.title,
    required this.bio,
    required this.avatarUrl,
    required this.skills,
    required this.education,
    required this.experience,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'location': location,
    'title': title,
    'bio': bio,
    'avatarUrl': avatarUrl,
    'skills': skills,
    'education': education.map((e) => e.toJson()).toList(),
    'experience': experience.map((e) => e.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json['id'] ?? '',
    userId: json['userId'] ?? '',
    fullName: json['fullName'] ?? '',
    email: json['email'] ?? '',
    phone: json['phone'] ?? '',
    location: json['location'] ?? '',
    title: json['title'] ?? '',
    bio: json['bio'] ?? '',
    avatarUrl: json['avatarUrl'] ?? '',
    skills: List<String>.from(json['skills'] ?? []),
    education: List<Education>.from(
      (json['education'] ?? []).map((x) => Education.fromJson(x))),
    experience: List<Experience>.from(
      (json['experience'] ?? []).map((x) => Experience.fromJson(x))),
    createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
  );

  Profile copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? email,
    String? phone,
    String? location,
    String? title,
    String? bio,
    String? avatarUrl,
    List<String>? skills,
    List<Education>? education,
    List<Experience>? experience,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      title: title ?? this.title,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      skills: skills ?? this.skills,
      education: education ?? this.education,
      experience: experience ?? this.experience,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}