import 'package:file_pod/features/auth/presentation/widgets/login_form.dart';
import 'package:file_pod/features/auth/presentation/widgets/login_header.dart';
import 'package:file_pod/features/auth/presentation/widgets/login_register_action.dart';
import 'package:file_pod/core/widgets/social_login.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LoginHeader(),
              const SizedBox(height: 28),
              LoginForm(),
              const SizedBox(height: 12),
              SizedBox(height: 24),
              SocialLogin(),
              SizedBox(height: 28),
              LoginRegisterAction(),
            ],
          ),
        ),
      ),
    );
  }
}
