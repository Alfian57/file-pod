import 'package:flutter/material.dart';
import 'package:file_pod/theme.dart';

class StorageDetailFileHeader extends StatelessWidget {
  const StorageDetailFileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('My Files', style: theme.textTheme.headlineSmall),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.tune, color: AppTheme.textPrimary),
        ),
      ],
    );
  }
}
