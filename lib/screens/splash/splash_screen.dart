import 'package:flutter/material.dart';
import 'package:scenario_management/route_names/route_names.dart';
import '../../constants/hive_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Add a slight delay to allow the widget to fully build before navigating
    Future.delayed(const Duration(milliseconds: 500), _checkLoginStatus);
  }

  Future<void> _checkLoginStatus() async {
    if (HiveService().isUserLoggedIn()) {
      // User is logged in, navigate to home page
      Navigator.pushNamed(context, RoutesName.homePageScreen);
    } else {
      // No user, navigate to login page
      Navigator.pushNamed(context, RoutesName.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
