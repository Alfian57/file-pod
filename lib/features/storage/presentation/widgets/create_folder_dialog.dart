import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/storage_controller.dart';

class CreateFolderDialog extends ConsumerStatefulWidget {
  const CreateFolderDialog({
    super.key,
    this.parentFolderId,
    required this.onSuccess,
  });

  final String? parentFolderId;
  final VoidCallback onSuccess;

  @override
  ConsumerState<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends ConsumerState<CreateFolderDialog> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Folder'),
      content: TextField(
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: 'Folder Name',
          hintText: 'Enter folder name',
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (_nameController.text.trim().isNotEmpty) {
              Navigator.pop(context);
              await ref
                  .read(storageControllerProvider.notifier)
                  .createFolder(
                    _nameController.text.trim(),
                    widget.parentFolderId,
                  );
              widget.onSuccess();
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
