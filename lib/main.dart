import 'package:flutter/material.dart';
import 'package:job_app/presentation/screens/auth/register_screen.dart';
import 'package:job_app/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:job_app/presentation/screens/auth/login_screen.dart';
import 'package:job_app/presentation/screens/home/home_screen.dart';
import 'package:job_app/presentation/screens/notifications/notification_screen.dart';
import 'package:job_app/presentation/screens/profiles/profile_screen.dart';
import 'package:job_app/presentation/screens/setting/settings_screen.dart';
import 'package:job_app/presentation/screens/messaging/messaging_screen.dart';

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
      initialRoute: '/home', // For testing
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/registration': (context) => const RegistrationScreen(),
        '/home': (context) {
          final username = ModalRoute.of(context)?.settings.arguments as String? ?? 'User';
          return HomeScreen(username: username);
        },
        '/notifications': (context) => const NotificationScreen(),
        '/profile': (context) {
          final username = ModalRoute.of(context)?.settings.arguments as String? ?? 'User';
          return ProfileScreen(username: username);
        },
        '/settings': (context) {
          final username = ModalRoute.of(context)?.settings.arguments as String? ?? 'User';
          return SettingsScreen(username: username);
        },
        '/messages': (context) {
          final username = ModalRoute.of(context)?.settings.arguments as String? ?? 'User';
          return MessagingScreen(username: username);
        },
      },
      debugShowCheckedModeBanner: false,
    );
  }
}