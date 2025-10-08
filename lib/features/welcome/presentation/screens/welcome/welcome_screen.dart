import 'package:file_pod/features/welcome/presentation/screens/welcome/widgets/welcome_background.dart';
import 'package:file_pod/features/welcome/presentation/screens/welcome/widgets/welcome_header.dart';
import 'package:file_pod/features/welcome/presentation/screens/welcome/widgets/welcome_actions.dart';
import 'package:file_pod/features/welcome/presentation/screens/welcome/widgets/social_login_buttons.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const WelcomeBackground(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                WelcomeHeader(),
                SizedBox(height: 32),
                WelcomeActions(),
                SizedBox(height: 32),
                Center(child: SocialLoginButtons()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
