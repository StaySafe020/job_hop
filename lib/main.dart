import 'package:flutter/material.dart';
import 'package:job_app/notifications/notification_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import '../services/connection_service.dart'; // Import your connection service
import 'onboard screen/onboard.dart';
import 'onboard screen/pageview.dart';
import 'authentication/login_screen.dart';
import 'authentication/registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await Firebase.initializeApp(); // Initialize Firebase

  // Test Firebase connection
  ConnectionService connectionService = ConnectionService();
  await connectionService.checkConnection(); // Call the check method
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => NotificationProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Hop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardScreen(),
        '/pageview': (context) => const OnboardingPageView(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
      },
    );
  }
}