import 'package:flutter/material.dart';
import 'package:file_pod/theme.dart';

class StorageFolderHeader extends StatelessWidget {
  const StorageFolderHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('My Folders', style: theme.textTheme.headlineSmall),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.add, color: AppTheme.textPrimary),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.tune, color: AppTheme.textPrimary),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.arrow_forward_ios, color: AppTheme.textPrimary),
            ),
          ],
        ),
      ],
    );
  }
}
