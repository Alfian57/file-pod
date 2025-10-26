import 'package:flutter/material.dart';
import 'package:file_pod/theme.dart';

class StorageActionMenu extends StatelessWidget {
  const StorageActionMenu({
    super.key,
    required this.onCreateFolder,
    required this.onUploadFile,
  });

  final VoidCallback onCreateFolder;
  final VoidCallback onUploadFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(
              Icons.create_new_folder,
              color: AppTheme.primary,
            ),
            title: const Text('Create Folder'),
            onTap: () {
              Navigator.pop(context);
              onCreateFolder();
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_file, color: AppTheme.primary),
            title: const Text('Upload File'),
            onTap: () {
              Navigator.pop(context);
              onUploadFile();
            },
          ),
        ],
      ),
    );
  }
}
