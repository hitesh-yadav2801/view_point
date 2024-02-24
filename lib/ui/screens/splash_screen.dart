import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:view_point/ui/screens/onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'lib/core/assets/animations/loading.json',
                width: 250,
                height: 250,
                fit: BoxFit.cover,
                repeat: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}