import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to login/registration after 19 seconds
    Future.delayed(const Duration(seconds: 19), () {
      Navigator.pushReplacementNamed(context, '/login'); // Adjust route name as needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 238, 238), // You can change the background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo widget - Replace with your actual logo asset
            Image.asset(
              'assets/images/Work From Home - Girl S.png', // Changed to a job-related image
              width: 180,
              height: 180,
            ),
            const SizedBox(height: 20), // Space between logo and text
            const Text(
              'Welcome to Job Hop',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Adjust color as needed
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Find your dream job, connect with top employers, and manage your career all in one place. Job Hop makes job searching, applications, and professional networking easy and effective.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}