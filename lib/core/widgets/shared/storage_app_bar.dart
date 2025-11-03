import 'package:flutter/material.dart';
import '../../../theme.dart';

class StorageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StorageAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      elevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      foregroundColor: AppTheme.textPrimary,
      title: Text(title, style: theme.textTheme.headlineSmall),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
