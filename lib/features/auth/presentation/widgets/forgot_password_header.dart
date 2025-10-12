import 'package:flutter/material.dart';

class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Forgot Password?', style: t.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'Enter your email to reset your password',
          style: t.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
        ),
      ],
    );
  }
}
