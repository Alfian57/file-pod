import 'package:flutter/material.dart';
import 'package:file_pod/theme.dart';
import 'profile_menu_item.dart';
import 'profile_section_title.dart';

/// Account Settings section for profile screen.
class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({
    super.key,
    required this.onEditProfile,
    required this.onChangePassword,
  });

  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ProfileSectionTitle(title: 'Account Settings'),
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
                icon: Icons.person_outline,
                title: 'Edit Profile',
                onTap: onEditProfile,
                iconColor: AppTheme.primary,
              ),
              const Divider(height: 1, indent: 56),
              ProfileMenuItem(
                icon: Icons.lock_outline,
                title: 'Change Password',
                onTap: onChangePassword,
                iconColor: Colors.orange,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
