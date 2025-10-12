import 'package:file_pod/features/auth/presentation/widgets/forgot_password_form.dart';
import 'package:file_pod/features/auth/presentation/widgets/forgot_password_header.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
              ForgotPasswordHeader(),
              const SizedBox(height: 28),
              ForgotPasswordForm(),
            ],
          ),
        ),
      ),
    );
  }
}
