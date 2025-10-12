import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = theme.textTheme;

    return Center(
      child: Column(
        children: [
          Text(
            'Use Social Login',
            textAlign: TextAlign.center,
            style: t.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(FontAwesomeIcons.google),
                color: theme.colorScheme.onSurface,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(FontAwesomeIcons.github),
                color: theme.colorScheme.onSurface,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
