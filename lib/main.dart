import 'package:flutter/material.dart';
import 'package:job_app/presentation/screens/auth/register_screen.dart';
import 'package:job_app/presentation/screens/notifications/notification_screen.dart';
import 'package:job_app/presentation/screens/onboarding/onboarding_screen.dart'; // Import onboarding screen
import 'package:job_app/presentation/screens/auth/login_screen.dart'; // Import the detailed login screen
import 'package:job_app/presentation/screens/home/home_screen.dart';



void main() {
  runApp(const JobHopApp());
}

class JobHopApp extends StatelessWidget {
  const JobHopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Hop',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Customize your app's theme
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/onboarding', // Start with onboarding screen
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(), // Uses LoginScreen from login_screen.dart
        '/registration': (context) => const RegistrationScreen(), // Uses RegistrationScreen from registration_screen.dart
        '/home': (context) => const HomeScreen(username: 'User'),
        '/notifications': (context) => const NotificationScreen(),
      },
      debugShowCheckedModeBanner: false, // Removes debug banner
    );
  }
}