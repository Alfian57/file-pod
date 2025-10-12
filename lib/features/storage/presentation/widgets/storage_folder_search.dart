import 'package:flutter/material.dart';

class StorageFolderSearch extends StatelessWidget {
  const StorageFolderSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withAlpha(40)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.search, size: 22, color: Color(0xFF6B6F76)),
          const SizedBox(width: 12),
          Text('Search  Folder', style: textTheme.titleSmall),
        ],
      ),
    );
  }
}
