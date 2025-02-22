import 'package:flutter/material.dart';
import 'package:job_app/presentation/screens/auth/register_screen.dart';
import 'package:job_app/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:job_app/presentation/screens/auth/login_screen.dart';
import 'package:job_app/presentation/screens/home/home_screen.dart'; // Import home screen

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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/home', // Start directly at home screen
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/registration': (context) => const RegistrationScreen(),
        '/home': (context) => const HomeScreen(username: 'TestUser'), // Hardcoded username
      },
      debugShowCheckedModeBanner: false,
    );
  }
}