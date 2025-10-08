import 'package:flutter/material.dart';
import 'package:file_pod/widgets/app_button.dart';

class WelcomeActions extends StatelessWidget {
  const WelcomeActions({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Join For Free.', style: t.titleSmall),
        const SizedBox(height: 32),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: 140,
                child: AppButton(
                  label: 'Register',
                  icon: Icons.person_add,
                  onPressed: () {},
                  type: AppButtonType.outlined,
                  iconOnRight: true,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 150,
                child: AppButton(
                  label: 'Sign in',
                  icon: Icons.arrow_right_alt,
                  onPressed: () {},
                  type: AppButtonType.primary,
                  iconOnRight: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
