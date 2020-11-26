import 'package:flutter/material.dart';
import 'package:roads/screens/Home/HomePage.dart';
import 'package:roads/screens/Settings/EditProfile.dart';
import 'package:roads/screens/Settings/settings.dart';

import 'main.dart';

class CustomRouter {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/home":
        return MaterialPageRoute(builder: (_) => HomePage());
      case "/settings":
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case '/editprofile':
        return MaterialPageRoute(builder: (_) => EditProfilePage());
      default:
        return MaterialPageRoute(builder: (_) => MyHomePage());
    }
  }
}
