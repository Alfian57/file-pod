import 'package:file_pod/core/widgets/shared/social_login.dart';
import 'package:file_pod/features/auth/presentation/widgets/register_form.dart';
import 'package:file_pod/features/auth/presentation/widgets/register_header.dart';
import 'package:file_pod/features/auth/presentation/widgets/register_login_action.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
              RegisterHeader(),
              const SizedBox(height: 28),
              RegisterForm(),
              const SizedBox(height: 24),
              const SocialLogin(),
              const SizedBox(height: 28),
              RegisterLoginAction(),
            ],
          ),
        ),
      ),
    );
  }
}
