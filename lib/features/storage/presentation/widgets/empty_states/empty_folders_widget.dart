import 'package:flutter/material.dart';

class EmptyFoldersWidget extends StatelessWidget {
  const EmptyFoldersWidget({super.key, this.showCreateHint = false});

  final bool showCreateHint;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(Icons.folder_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              showCreateHint ? 'No folders yet' : 'No subfolders',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            if (showCreateHint) ...[
              const SizedBox(height: 8),
              Text(
                'Tap the + button to create a folder',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
