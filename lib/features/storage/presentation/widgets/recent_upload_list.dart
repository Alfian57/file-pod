import 'package:flutter/material.dart';
import 'package:file_pod/core/widgets/recent_upload_item.dart';

class RecentUploadList extends StatelessWidget {
  const RecentUploadList({super.key});

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
