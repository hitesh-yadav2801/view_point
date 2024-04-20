import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:view_point/core/constants/my_colors.dart';
import 'package:view_point/ui/common_widgets/custom_button.dart';
import 'package:view_point/ui/screens/faq_screen.dart';
import 'package:view_point/ui/screens/instructions_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/onboard.json',
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.7,
                  fit: BoxFit.cover,
                  repeat: true,
                ),
                const Spacer(),
                const Text(
                  'Welcome!',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Let\'s dive into the world of \ncinematic opinions together!',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 48),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: 'FAQ\'s',
                        color: Colors.transparent,
                        textColor: MyColors.blackColor,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FAQScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        title: 'Instructions',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const InstructionsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
