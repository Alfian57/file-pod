import 'package:flutter/material.dart';

class RenameDialog {
  static Future<String?> show({
    required BuildContext context,
    required String currentName,
    required String type, // 'File' or 'Folder'
  }) async {
    final TextEditingController controller = TextEditingController(text: currentName);
    
    // Select the filename part without extension if it's a file
    String nameWithoutExt = currentName;
    String extension = '';
    
    if (type == 'File' && currentName.contains('.')) {
      final lastDotIndex = currentName.lastIndexOf('.');
      nameWithoutExt = currentName.substring(0, lastDotIndex);
      extension = currentName.substring(lastDotIndex);
    }

    controller.text = nameWithoutExt;
    controller.selection = TextSelection(
      baseOffset: 0, 
      extentOffset: nameWithoutExt.length,
    );

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rename $type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Name',
                suffixText: extension.isNotEmpty ? extension : null,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                Navigator.pop(context, '$newName$extension');
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }
}
