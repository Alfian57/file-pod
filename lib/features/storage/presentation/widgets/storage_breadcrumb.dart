import 'package:file_pod/features/storage/domain/entities/folder_entity.dart';
import 'package:flutter/material.dart';

class StorageBreadcrumb extends StatelessWidget {
  const StorageBreadcrumb({
    super.key,
    required this.ancestors,
    this.currentFolder,
    required this.onFolderTap,
  });

  final List<FolderEntity> ancestors;
  final FolderEntity? currentFolder;
  final Function(String?) onFolderTap; // Pass null for root

  @override
  Widget build(BuildContext context) {
    // Combine ancestors and current folder (if explicitly passed, though ancestors might be enough if logic handles it)
    // Ancestors: [Root, ..., Parent]
    // Current: [Current]
    
    // We want to display: "My Storage > Ancestor1 > Ancestor2 > Current"
    
    final items = [
      _BreadcrumbItem(id: null, name: "My Storage"),
      ...ancestors.map((f) => _BreadcrumbItem(id: f.id, name: f.name)),
      if (currentFolder != null)
        _BreadcrumbItem(id: currentFolder!.id, name: currentFolder!.name),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Important for Row in ScrollView
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: isLast ? null : () => onFolderTap(item.id),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Text(
                    item.name,
                    style: TextStyle(
                      color: isLast ? Colors.black87 : Colors.grey[600],
                      fontWeight: isLast ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: Colors.grey[400],
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _BreadcrumbItem {
  final String? id;
  final String name;

  _BreadcrumbItem({required this.id, required this.name});
}
