import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:view_point/data/services/firebase_auth_services.dart';
import 'package:view_point/ui/screens/admin_panel_screen.dart';
import 'package:view_point/ui/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboardingScreen();
  }
  @override
  void dispose() {

    super.dispose();
  }

  void _navigateToOnboardingScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
      if(firebaseAuthServices.authentication.currentUser != null) {
        //print(firebaseAuthServices.authentication.currentUser);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminPanelScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/loading.json',
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
