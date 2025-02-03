class JobModel {
  final String id; // Unique ID for the job
  final String title; // Job title
  final String description; // Job description
  final double salary; // Salary for the job
  final String location; // Job location
  final String companyName; // Name of the company offering the job
  final String companyLogoUrl; // URL to the company logo
  final String employerId; // ID of the employer who posted the job
  final DateTime? postedAt; // Timestamp when the job was posted (optional)
  final List<String>? requiredSkills; // List of required skills (optional)
  final String? jobType; // Job type (e.g., Full-time, Part-time, Remote)

  JobModel({
    required this.id,
    required this.title,
    required this.description,
    required this.salary,
    required this.location,
    required this.companyName,
    required this.companyLogoUrl,
    required this.employerId,
    this.postedAt,
    this.requiredSkills,
    this.jobType,
  });

  // Convert model to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'salary': salary,
      'location': location,
      'companyName': companyName,
      'companyLogoUrl': companyLogoUrl,
      'employerId': employerId,
      'postedAt': postedAt?.toIso8601String(), // Convert DateTime to String
      'requiredSkills': requiredSkills,
      'jobType': jobType,
    };
  }

  // Create model from Firestore document
  factory JobModel.fromMap(Map<String, dynamic> data) {
    return JobModel(
      id: data['id'] ?? '', // Ensure id is not null
      title: data['title'] ?? '', // Ensure title is not null
      description: data['description'] ?? '', // Ensure description is not null
      salary: data['salary'] ?? 0.0, // Default salary is 0.0
      location: data['location'] ?? '', // Ensure location is not null
      companyName: data['companyName'] ?? '', // Ensure companyName is not null
      companyLogoUrl: data['companyLogoUrl'] ?? '', // Ensure companyLogoUrl is not null
      employerId: data['employerId'] ?? '', // Ensure employerId is not null
      postedAt: data['postedAt'] != null ? DateTime.parse(data['postedAt']) : null,
      requiredSkills: List<String>.from(data['requiredSkills'] ?? []), // Handle null skills
      jobType: data['jobType'],
    );
  }

  // Override toString() for debugging
  @override
  String toString() {
    return 'JobModel(id: $id, title: $title, description: $description, salary: $salary, location: $location, companyName: $companyName, companyLogoUrl: $companyLogoUrl, employerId: $employerId, postedAt: $postedAt, requiredSkills: $requiredSkills, jobType: $jobType)';
  }
}