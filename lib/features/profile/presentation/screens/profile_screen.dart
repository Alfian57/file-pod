import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:file_picker/file_picker.dart';
import 'package:file_pod/core/configs/router-configs/route_names.dart';
import 'package:file_pod/core/widgets/shared/storage_app_bar.dart';
import 'package:file_pod/core/widgets/shared/storage_bottom_navigation_bar.dart';
import 'package:file_pod/features/auth/presentation/controllers/auth_controller.dart';
import 'package:file_pod/features/profile/presentation/widgets/sheets/change_password_sheet.dart';
import 'package:file_pod/features/profile/presentation/widgets/sheets/edit_profile_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../theme.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_storage_info.dart';

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
        // Ensure we send the current name along with the image
        final currentName = ref.read(profileControllerProvider).user?.name;
        await ref
            .read(profileControllerProvider.notifier)
            .updateProfile(currentName, file.path);
      }
    }
  }

  Future<void> _logout() async {
    // Show confirmation dialog
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
                          // Settings Section
                          _buildSectionTitle('Account Settings'),
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
                                _buildMenuItem(
                                  icon: Icons.person_outline,
                                  title: 'Edit Profile',
                                  onTap: _showEditProfileSheet,
                                  color: AppTheme.primary,
                                ),
                                const Divider(height: 1, indent: 56),
                                _buildMenuItem(
                                  icon: Icons.lock_outline,
                                  title: 'Change Password',
                                  onTap: _showChangePasswordSheet,
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Support Section
                          _buildSectionTitle('Support & Legal'),
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
                                _buildMenuItem(
                                  icon: Icons.help_outline,
                                  title: 'FAQ',
                                  onTap: () => _showInfoDialog(
                                    'Frequently Asked Questions', 
                                    'Q: How do I store files?\nA: Simply upload them via the Storage tab.\n\n'
                                    'Q: Is my data secure?\nA: Yes, we use industry-standard encryption.\n\n'
                                    'Q: Can I share folders?\nA: Yes, you can generate share links for any folder.'
                                  ),
                                  color: Colors.blue,
                                ),
                                const Divider(height: 1, indent: 56),
                                _buildMenuItem(
                                  icon: Icons.info_outline,
                                  title: 'About Us',
                                  onTap: () => _showInfoDialog(
                                    'About FilePod', 
                                    'FilePod is your secure, personal cloud storage solution. \n\n'
                                    'Version: 1.0.0\n'
                                    'Developed by: Deepmind Team\n'
                                    '© 2024 FilePod Inc.'
                                  ),
                                  color: Colors.purple,
                                ),
                                const Divider(height: 1, indent: 56),
                                _buildMenuItem(
                                  icon: Icons.description_outlined,
                                  title: 'Terms & Conditions',
                                  onTap: () => _showInfoDialog(
                                    'Terms & Conditions', 
                                    '1. Acceptance of Terms\naccessing this app, you agree to be bound by these terms.\n\n'
                                    '2. User Conduct\nYou agree not to misuse the service or upload illegal content.\n\n'
                                    '3. Liability\nWe are not liable for data loss due to unforeseen circumstances.'
                                  ),
                                  color: Colors.teal,
                                ),
                                const Divider(height: 1, indent: 56),
                                _buildMenuItem(
                                  icon: Icons.privacy_tip_outlined,
                                  title: 'Privacy Policy',
                                  onTap: () => _showInfoDialog(
                                    'Privacy Policy', 
                                    'We value your privacy.\n\n'
                                    '1. Data Collection\nWe collect only essential data to provide our service.\n\n'
                                    '2. Data Usage\nWe do not sell your personal data to third parties.'
                                  ),
                                  color: Colors.indigo,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 48),
                          _buildLogoutButton(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: const StorageBottomNavigationBar(),
    );
  }

  Widget _buildSectionTitle(String title) {
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

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: onTap,
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

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _logout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.red,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
           shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.red.withOpacity(0.2)),
          ),
        ),
        child: const Text(
          'Log Out',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


}
