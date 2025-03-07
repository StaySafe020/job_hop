import 'package:flutter/material.dart';
import 'package:job_app/presentation/screens/admin/admin_screen.dart';
import 'package:job_app/presentation/screens/home/home_screen.dart';
import 'package:job_app/presentation/screens/messaging/messaging_screen.dart';
import 'package:job_app/presentation/screens/notifications/notification_screen.dart';
import 'package:job_app/presentation/screens/profiles/employer_profile_screen.dart';
import 'package:job_app/presentation/screens/profiles/payment_screen.dart';
import 'package:job_app/presentation/screens/profiles/profile_screen.dart';
import 'package:job_app/presentation/screens/profiles/profile_viewer_screen.dart';
import 'package:job_app/presentation/screens/setting/settings_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Hop',
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(username: ModalRoute.of(context)?.settings.arguments as String? ?? 'User'),
        '/profile': (context) => ProfileScreen(username: ModalRoute.of(context)?.settings.arguments as String? ?? 'User'),
        '/settings': (context) => SettingsScreen(username: ModalRoute.of(context)?.settings.arguments as String? ?? 'User'),
        '/notifications': (context) => const NotificationScreen(),
        '/messages': (context) => MessagingScreen(username: ModalRoute.of(context)?.settings.arguments as String? ?? 'User'),
        '/profile_viewer': (context) => ProfileViewerScreen(userId: ModalRoute.of(context)?.settings.arguments as String? ?? 'unknown'),
        '/employer_profile': (context) => EmployerProfileScreen(employerId: ModalRoute.of(context)?.settings.arguments as String? ?? 'unknown'),
        '/payment': (context) => PaymentScreen(
              onPaymentComplete: (method) => print('Payment completed with $method'), // Placeholder callback
            ),
        '/admin': (context) {
          // TODO: Implement role check for admin access
          // Example: bool isAdmin = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get().then((doc) => doc['isAdmin'] ?? false);
          // if (!isAdmin) return HomeScreen(username: 'User');
          return const AdminScreen();
        },
      },
    );
  }
}