import 'package:flutter/material.dart';
import 'package:file_pod/features/storage/presentation/widgets/recent_upload_item.dart';

class StorageDetailRecentUploadList extends StatelessWidget {
  const StorageDetailRecentUploadList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RecentUploadItem(),
        const Divider(height: 1, thickness: 1),
        const RecentUploadItem(),
        const Divider(height: 1, thickness: 1),
        const RecentUploadItem(),
      ],
    );
  }
}
