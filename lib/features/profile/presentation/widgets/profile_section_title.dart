import 'package:flutter/material.dart';

/// Reusable section title widget for profile screen sections.
class ProfileSectionTitle extends StatelessWidget {
  const ProfileSectionTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
