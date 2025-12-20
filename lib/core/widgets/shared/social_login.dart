import 'package:file_pod/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLogin extends ConsumerWidget {
  const SocialLogin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final t = theme.textTheme;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Or continue with',
                style: t.bodyMedium?.copyWith(color: Colors.grey.shade600),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                ref.read(authControllerProvider.notifier).loginWithGoogle();
              },
              icon: const FaIcon(
                FontAwesomeIcons.google,
                size: 24, // Slightly larger for visibility
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 24), // Spacing between icons
            IconButton(
              onPressed: () {
                ref.read(authControllerProvider.notifier).loginWithGitHub();
              },
              icon: const FaIcon(
                FontAwesomeIcons.github,
                size: 24,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
