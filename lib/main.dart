import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:view_point/core/constants/my_colors.dart';
import 'package:view_point/ui/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        primaryColor: MyColors.primaryColor,
        useMaterial3: true,
        textTheme: GoogleFonts.openSansTextTheme(),
      ),

      home: const SplashScreen(),
    );
  }
}