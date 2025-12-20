import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/storage_controller.dart';
import '../utils/folder_color_provider.dart';

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
  int _selectedColorValue = FolderColorProvider.availableColors[0].background.value;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Folder'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Folder Name',
              hintText: 'Enter folder name',
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          const Text('Folder Color', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: FolderColorProvider.availableColors.map((color) {
                final isSelected = color.background.value == _selectedColorValue;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColorValue = color.background.value;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: color.icon, width: 2)
                          : null,
                    ),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color.background,
                        shape: BoxShape.circle,
                      ),
                      child: isSelected
                          ? Icon(Icons.check, size: 16, color: color.icon)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
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
                    color: _selectedColorValue.toString(),
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
