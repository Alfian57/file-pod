import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_pod/core/configs/router-configs/route_names.dart';
import 'package:file_pod/core/widgets/shared/storage_app_bar.dart';
import 'package:file_pod/core/widgets/shared/storage_bottom_navigation_bar.dart';
import 'package:file_pod/features/auth/presentation/controllers/auth_controller.dart';
import 'package:file_pod/features/profile/presentation/widgets/profile_logout_button.dart';
import 'package:file_pod/features/profile/presentation/widgets/profile_settings_section.dart';
import 'package:file_pod/features/profile/presentation/widgets/profile_support_section.dart';
import 'package:file_pod/features/profile/presentation/widgets/sheets/change_password_sheet.dart';
import 'package:file_pod/features/profile/presentation/widgets/sheets/edit_profile_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileControllerProvider.notifier).getCurrentUser();
    });
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);

      if (!mounted) return;

      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Update Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Do you want to update your profile picture?'),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 40,
                backgroundImage: FileImage(file),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Update'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        final currentName = ref.read(profileControllerProvider).user?.name;
        await ref
            .read(profileControllerProvider.notifier)
            .updateProfile(currentName, file.path);
      }
    }
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      await ref.read(authControllerProvider.notifier).logout();
      if (mounted) {
        context.goNamed(RouteNames.login);
      }
    }
  }

  void _showEditProfileSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EditProfileSheet(),
    );
  }

  void _showChangePasswordSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ChangePasswordSheet(),
    );
  }

  void _showInfoDialog(String title, String content) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.bottomSlide,
      title: title,
      desc: content,
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileControllerProvider);

    ref.listen(profileControllerProvider, (previous, next) {
      if (next.error != null && !next.isLoading) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: 'Error',
          desc: next.error,
          btnOkOnPress: () {},
        ).show();
      } else if (next.successMessage != null && !next.isLoading) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: 'Success',
          desc: next.successMessage,
          btnOkOnPress: () {},
        ).show();
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const StorageAppBar(title: "My Profile"),
      body: SafeArea(
        child: state.isLoading && state.user == null
            ? const Center(child: CircularProgressIndicator())
            : state.user == null
                ? const Center(child: Text('Failed to load profile'))
                : RefreshIndicator(
                    onRefresh: () async {
                      await ref
                          .read(profileControllerProvider.notifier)
                          .getCurrentUser();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 24),
                      child: Column(
                        children: [
                          _buildProfileHeader(state),
                          const SizedBox(height: 32),
                          ProfileSettingsSection(
                            onEditProfile: _showEditProfileSheet,
                            onChangePassword: _showChangePasswordSheet,
                          ),
                          const SizedBox(height: 24),
                          ProfileSupportSection(
                            onFaq: () => _showInfoDialog(
                              'Frequently Asked Questions',
                              'Q: How do I store files?\nA: Simply upload them via the Storage tab.\n\n'
                              'Q: Is my data secure?\nA: Yes, we use industry-standard encryption.\n\n'
                              'Q: Can I share folders?\nA: Yes, you can generate share links for any folder.',
                            ),
                            onAboutUs: () => _showInfoDialog(
                              'About FilePod',
                              'FilePod is your secure, personal cloud storage solution. \n\n'
                              'Version: 1.0.0\n'
                              'Developed by: Deepmind Team\n'
                              '© 2025 FilePod Inc.',
                            ),
                            onTerms: () => _showInfoDialog(
                              'Terms & Conditions',
                              '1. Acceptance of Terms\nBy accessing this app, you agree to be bound by these terms.\n\n'
                              '2. User Conduct\nYou agree not to misuse the service or upload illegal content.\n\n'
                              '3. Liability\nWe are not liable for data loss due to unforeseen circumstances.',
                            ),
                            onPrivacy: () => _showInfoDialog(
                              'Privacy Policy',
                              'We value your privacy.\n\n'
                              '1. Data Collection\nWe collect only essential data to provide our service.\n\n'
                              '2. Data Usage\nWe do not sell your personal data to third parties.',
                            ),
                          ),
                          const SizedBox(height: 48),
                          ProfileLogoutButton(onPressed: _logout),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: const StorageBottomNavigationBar(),
    );
  }

  Widget _buildProfileHeader(ProfileState state) {
    final user = state.user!;
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primary.withOpacity(0.1),
                  backgroundImage: user.profilePictureUrl != null
                      ? NetworkImage(user.profilePictureUrl!)
                      : null,
                  child: user.profilePictureUrl == null
                      ? Text(
                          user.name?[0].toUpperCase() ?? 'U',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        )
                      : null,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user.name ?? 'Guest User',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
