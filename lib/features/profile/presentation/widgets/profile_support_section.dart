import 'package:flutter/material.dart';
import 'profile_menu_item.dart';
import 'profile_section_title.dart';

/// Support & Legal section for profile screen.
class ProfileSupportSection extends StatelessWidget {
  const ProfileSupportSection({
    super.key,
    required this.onFaq,
    required this.onAboutUs,
    required this.onTerms,
    required this.onPrivacy,
  });

  final VoidCallback onFaq;
  final VoidCallback onAboutUs;
  final VoidCallback onTerms;
  final VoidCallback onPrivacy;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ProfileSectionTitle(title: 'Support & Legal'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              ProfileMenuItem(
                icon: Icons.help_outline,
                title: 'FAQ',
                onTap: onFaq,
                iconColor: Colors.blue,
              ),
              const Divider(height: 1, indent: 56),
              ProfileMenuItem(
                icon: Icons.info_outline,
                title: 'About Us',
                onTap: onAboutUs,
                iconColor: Colors.purple,
              ),
              const Divider(height: 1, indent: 56),
              ProfileMenuItem(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                onTap: onTerms,
                iconColor: Colors.teal,
              ),
              const Divider(height: 1, indent: 56),
              ProfileMenuItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: onPrivacy,
                iconColor: Colors.indigo,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
