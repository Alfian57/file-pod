import 'package:flutter/material.dart';
import 'package:file_pod/features/storage/presentation/widgets/folder_card.dart';

class StorageFolderGrid extends StatelessWidget {
  const StorageFolderGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.45,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        FolderCard(
          title: 'Mobile Apps',
          date: 'December 20, 2020',
          bgColor: const Color(0xFFEAF5FF),
          iconColor: const Color(0xFF4B6BE6),
          textColor: const Color(0xFF4B6BE6),
        ),
        FolderCard(
          title: 'SVG Icons',
          date: 'December 14, 2020',
          bgColor: const Color(0xFFFFF6E6),
          iconColor: const Color(0xFFF5B400),
          textColor: const Color(0xFFF5B400),
        ),
        FolderCard(
          title: 'Prototypes',
          date: 'November 22, 2020',
          bgColor: const Color(0xFFFFEFEF),
          iconColor: const Color(0xFFD94B48),
          textColor: const Color(0xFFD94B48),
        ),
        FolderCard(
          title: 'Avatars',
          date: 'November 10, 2020',
          bgColor: const Color(0xFFE8FFFB),
          iconColor: const Color(0xFF13C8B7),
          textColor: const Color(0xFF13C8B7),
        ),
      ],
    );
  }
}
