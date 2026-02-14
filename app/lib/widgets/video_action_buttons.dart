import 'package:flutter/material.dart';
import '../config/theme.dart';

class VideoActionButtons extends StatelessWidget {
  final bool isFavorited;
  final bool isCompleted;
  final VoidCallback onFavoriteTap;
  final VoidCallback onCompletedTap;
  final VoidCallback? onBookmarkTap;

  const VideoActionButtons({
    super.key,
    required this.isFavorited,
    required this.isCompleted,
    required this.onFavoriteTap,
    required this.onCompletedTap,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bookmark
        GestureDetector(
          onTap: onBookmarkTap,
          child: const Icon(
            Icons.star_border,
            color: VictusTheme.textLight,
            size: 26,
          ),
        ),
        const SizedBox(width: 16),
        // Favorite (heart)
        GestureDetector(
          onTap: onFavoriteTap,
          child: Icon(
            isFavorited ? Icons.favorite : Icons.favorite_border,
            color: isFavorited
                ? VictusTheme.primaryPink
                : VictusTheme.textLight,
            size: 26,
          ),
        ),
        const SizedBox(width: 16),
        // Completed (check)
        GestureDetector(
          onTap: onCompletedTap,
          child: Icon(
            isCompleted ? Icons.check_circle : Icons.check_circle_outline,
            color: isCompleted
                ? VictusTheme.accentGreen
                : VictusTheme.textLight,
            size: 26,
          ),
        ),
      ],
    );
  }
}