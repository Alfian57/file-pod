import 'package:flutter/material.dart';

class FolderCard extends StatelessWidget {
  const FolderCard({
    super.key,
    required this.title,
    required this.date,
    required this.bgColor,
    required this.iconColor,
    required this.textColor,
    this.onMorePressed,
  });

  final String title;
  final String date;
  final Color bgColor;
  final Color iconColor;
  final Color textColor;
  final VoidCallback? onMorePressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 150),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 28,
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha((0.15 * 255).round()),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(Icons.folder, color: iconColor, size: 18),
                ),
                GestureDetector(
                  onTap: onMorePressed,
                  child: Icon(
                    Icons.more_vert,
                    size: 18,
                    color: colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                  ),
                ),
              ],
            ),

            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    date,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withAlpha(
                        (0.6 * 255).round(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
