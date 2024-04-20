import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:view_point/blocs/category_bloc/category_bloc.dart';
import 'package:view_point/blocs/feedback_bloc/feedback_bloc.dart';
import 'package:view_point/core/constants/my_colors.dart';
import 'package:view_point/firebase_options.dart';
import 'package:view_point/ui/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoryBloc(),
        ),
        BlocProvider(
          create: (context) => FeedbackBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
