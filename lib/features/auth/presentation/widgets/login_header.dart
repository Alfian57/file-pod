import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome Back', style: t.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'Login to continue',
          style: t.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
        ),
      ],
    );
  }
}
