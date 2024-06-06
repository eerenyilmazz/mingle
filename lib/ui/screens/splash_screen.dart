import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mingle/ui/screens/start_screen.dart';
import 'package:mingle/ui/screens/top_navigation_screen.dart';
import '../../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';

  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _navigateToNextScreen();
  }

  _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _opacity = 1.0;
    });
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
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 1),
              child: Text(
                'Mingle',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: kAccentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
