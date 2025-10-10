import 'package:file_pod/core/widgets/app_button.dart';
import 'package:flutter/material.dart';

class StorageStatExportButton extends StatelessWidget {
  const StorageStatExportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        onPressed: () {},
        label: 'Export Details',
        icon: Icons.download_outlined,
        iconOnRight: true,
      ),
    );
  }
}
