import 'package:flutter/material.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('lib/assets/images/welcome-illustration.png', width: 170),
        const SizedBox(height: 24),
        Text('Welcome To', style: t.titleMedium),
        Text(
          'FilePod',
          style: t.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          'Best cloud storage platform for all business and individuals to manage their data',
          style: t.bodyMedium,
        ),
      ],
    );
  }
}
