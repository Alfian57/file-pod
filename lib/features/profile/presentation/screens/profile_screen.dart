import 'package:file_pod/core/widgets/shared/storage_bottom_navigation_bar.dart';
import 'package:file_pod/features/profile/presentation/controllers/profile_controller.dart';
import 'package:file_pod/features/profile/presentation/widgets/profile_header.dart';
import 'package:file_pod/features/profile/presentation/widgets/profile_menu_list.dart';
import 'package:file_pod/features/profile/presentation/widgets/profile_storage_info.dart';
import 'package:file_pod/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileState = ref.watch(profileControllerProvider);

    // Listen to error and success messages
    ref.listen(profileControllerProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
      }
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: Colors.green,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        title: Text('Profile', style: theme.textTheme.headlineSmall),
        centerTitle: false,
      ),
      body: profileState.isLoading && profileState.user == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(profileControllerProvider.notifier)
                    .getCurrentUser();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileHeader(user: profileState.user),
                    const SizedBox(height: 24),
                    ProfileStorageInfo(user: profileState.user),
                    const SizedBox(height: 32),
                    Text('Settings', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 16),
                    ProfileMenuList(),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: const StorageBottomNavigationBar(),
    );
  }
}
