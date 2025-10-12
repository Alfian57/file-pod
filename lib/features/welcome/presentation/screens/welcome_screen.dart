import 'package:file_pod/features/welcome/presentation/widgets/welcome_background.dart';
import 'package:file_pod/features/welcome/presentation/widgets/welcome_header.dart';
import 'package:file_pod/features/welcome/presentation/widgets/welcome_actions.dart';
import 'package:file_pod/core/widgets/social_login.dart';
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
                SocialLogin(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
