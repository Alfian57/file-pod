import 'package:file_pod/features/storage/domain/entities/file_entity.dart';
import 'package:file_pod/features/storage/presentation/screens/file_preview_screen.dart';
import 'package:flutter/material.dart';


class FilePreviewHandler {
  static void showPreview({
    required BuildContext context,
    required FileEntity file,
  }) {
    // Navigate to Full Screen Preview
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FilePreviewScreen(file: file),
        ),
    );
  }

}


