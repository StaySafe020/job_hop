import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:job_app/models/job_model.dart';
import 'package:job_app/models/review_model.dart';
import 'package:job_app/providers/chat_provider.dart';
import 'package:job_app/providers/job_provider.dart';
import 'package:job_app/providers/user_provider.dart';
import 'package:job_app/screens/auth/login_screen.dart';
import 'package:job_app/screens/job_seeker/home_screen.dart';
import 'package:job_app/screens/job_seeker/profile_screen.dart';
import 'package:job_app/screens/job_seeker/settings_screen.dart';
import 'package:job_app/screens/shared/job_details_screen.dart';
import 'package:job_app/screens/shared/review_screen.dart';
import 'firebase_options.dart'; // Firebase configuration file
import 'utils/theme.dart'; // Custom theme file

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'JobHop', // App name
        debugShowCheckedModeBanner: false, // Remove debug banner
        theme: AppTheme.lightTheme, // Use custom light theme
        darkTheme: AppTheme.darkTheme, // Use custom dark theme
        themeMode: ThemeMode.system, // Follow system theme
        home: LoginScreen(), // Start with the login screen
        routes: {
          '/home': (context) => MainNavigation(), // Use MainNavigation for the home route
          '/profile': (context) => ProfileScreen(),
          '/job-details': (context) => JobDetailsScreen(job: ModalRoute.of(context)!.settings.arguments as JobModel),
          '/reviews': (context) => ReviewScreen(reviews: ModalRoute.of(context)!.settings.arguments as List<ReviewModel>),
        },
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Screens for bottom navigation
  final List<Widget> _screens = [
    HomeScreen(),
    JobDetailsScreen(job: JobModel(
      id: '1',
      title: 'Sample Job',
      description: 'This is a sample job description.',
      salary: 50000,
      location: 'New York',
      companyName: 'Sample Company',
      companyLogoUrl: 'https://via.placeholder.com/150',
      employerId: 'employer1',
    )),
    ProfileScreen(),
    SettingsScreen(),
  ];

  // Bottom navigation items
  final List<BottomNavigationBarItem> _bottomNavItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.work),
      label: 'Jobs',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JobHop'),
        leading: _selectedIndex != 0
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0; // Go back to the home screen
                  });
                },
              )
            : null,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: _bottomNavItems,
      ),
    );
  }
}