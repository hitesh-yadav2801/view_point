import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:view_point/core/constants/my_colors.dart';
import 'package:view_point/ui/common_widgets/custom_button.dart';
import 'package:view_point/ui/screens/category_screen.dart';
import 'package:view_point/ui/screens/login_screen.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Instructions',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInstructionItem(
                      icon: Icons.person,
                      text: 'Start trial to watch videos.',
                    ),
                    _buildInstructionItem(
                      icon: Icons.admin_panel_settings,
                      text: 'Contact the super administrator for admin access.',
                    ),
                    _buildInstructionItem(
                      icon: Icons.category,
                      text: 'Explore video categories to find content.',
                    ),
                    _buildInstructionItem(
                      icon: Icons.feedback,
                      text:
                          'Leave feedback on videos to improve your experience.',
                    ),
                  ],
                ),
              ),
              CustomButton(
                title: 'Start Trial',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoryScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                title: 'Login as an Admin',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                color: Colors.transparent,
                textColor: MyColors.blackColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
