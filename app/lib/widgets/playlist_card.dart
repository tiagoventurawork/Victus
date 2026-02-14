import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/theme.dart';
import '../models/playlist.dart';

class PlaylistCard extends StatelessWidget {
  final PlaylistModel playlist;
  final VoidCallback onTap;

  const PlaylistCard({
    super.key,
    required this.playlist,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: VictusTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(VictusTheme.radiusMedium),
          boxShadow: VictusTheme.softShadow,
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(VictusTheme.radiusSmall),
              child: SizedBox(
                width: 100,
                height: 75,
                child: playlist.coverUrl != null
                    ? CachedNetworkImage(
                        imageUrl: playlist.coverUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          color: VictusTheme.primaryPinkLight,
                          child: const Icon(Icons.play_circle_outline,
                              color: VictusTheme.primaryPink),
                        ),
                      )
                    : Container(
                        color: VictusTheme.primaryPinkLight,
                        child: const Icon(Icons.play_circle_outline,
                            color: VictusTheme.primaryPink),
                      ),
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.title,
                    style: VictusTheme.heading3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (playlist.description != null &&
                      playlist.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      playlist.description!,
                      style: VictusTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (playlist.progress > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: playlist.progress / 100,
                              backgroundColor: VictusTheme.divider,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                VictusTheme.accentRed,
                              ),
                              minHeight: 4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${playlist.progress.toStringAsFixed(0)}%',
                          style: VictusTheme.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: VictusTheme.accentRed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}