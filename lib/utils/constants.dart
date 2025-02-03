import 'dart:ui';

import 'package:flutter/material.dart';

class AppConstants {
  // App Name
  static const String appName = 'JobHop';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String jobsCollection = 'jobs';
  static const String applicationsCollection = 'applications';
  static const String reviewsCollection = 'reviews';
  static const String chatsCollection = 'chats';

  // Default Values
  static const String defaultProfileImage =
      'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y';
  static const String defaultCompanyLogo =
      'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y';

  // Padding and Margins
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double defaultBorderRadius = 12.0;

  // Text Sizes
  static const double smallTextSize = 12.0;
  static const double mediumTextSize = 14.0;
  static const double largeTextSize = 16.0;
  static const double extraLargeTextSize = 18.0;

  // Colors
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.green;
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color warningColor = Colors.amber;
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black;
  static const Color hintColor = Colors.grey;
}