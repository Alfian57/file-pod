import 'package:flutter/material.dart';
import 'package:file_pod/theme.dart';

class RecentUploadHeader extends StatelessWidget {
  const RecentUploadHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Recent Uploads', style: theme.textTheme.headlineSmall),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.swap_vert, color: AppTheme.textPrimary),
        ),
      ],
    );
  }
}
