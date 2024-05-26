import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mingle/ui/screens/start_screen.dart';
import 'package:mingle/ui/screens/top_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';

  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.of(context).pushNamedAndRemoveUntil(TopNavigationScreen.id, (route) => false);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(StartScreen.id, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
