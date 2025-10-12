import 'package:flutter/material.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Create Account', style: t.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'Register to get started',
          style: t.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
        ),
      ],
    );
  }
}
