import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/playlist.dart';

class LessonTile extends StatefulWidget {
  final LessonModel lesson;
  final int index;
  final void Function(VideoItemModel video) onVideoTap;

  const LessonTile({
    super.key,
    required this.lesson,
    required this.index,
    required this.onVideoTap,
  });

  @override
  State<LessonTile> createState() => _LessonTileState();
}

class _LessonTileState extends State<LessonTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    
    return Column(
      children: [
        // Lesson header
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: VictusTheme.backgroundWhite,
              border: Border(
                bottom: BorderSide(
                  color: VictusTheme.divider.withOpacity(0.5),
                ),
              ),
            ),
            child: Row(
              children: [
                // Status icon
                _buildStatusIcon(lesson),
                const SizedBox(width: 12),
                // Title
                Expanded(
                  child: Text(
                    '${widget.index + 1} | ${lesson.title}',
                    style: VictusTheme.heading3.copyWith(fontSize: 15),
                  ),
                ),
                // Expand arrow
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: VictusTheme.textLight,
                ),
              ],
            ),
          ),
        ),
        // Videos list (expanded)
        if (_expanded)
          Container(
            color: VictusTheme.cardBackground,
            child: Column(
              children: lesson.videos.map((video) {
                return InkWell(
                  onTap: lesson.isFree || lesson.isCompleted
                      ? () => widget.onVideoTap(video)
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: VictusTheme.divider.withOpacity(0.3),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          video.isCompleted
                              ? Icons.check_circle
                              : Icons.play_circle_outline,
                          size: 20,
                          color: video.isCompleted
                              ? VictusTheme.accentGreen
                              : VictusTheme.primaryPink,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.title,
                                style: VictusTheme.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (video.progress != null) ...[
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: LinearProgressIndicator(
                                    value: video.progress!.percentage / 100,
                                    backgroundColor: VictusTheme.divider,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                      VictusTheme.primaryPink,
                                    ),
                                    minHeight: 3,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Text(
                          _formatDuration(video.duration),
                          style: VictusTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusIcon(LessonModel lesson) {
    if (lesson.isCompleted) {
      return Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: VictusTheme.accentGreen,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 16),
      );
    }

    if (!lesson.isFree) {
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: VictusTheme.textLight.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.lock, color: VictusTheme.textLight, size: 14),
      );
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: VictusTheme.primaryPink.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.play_arrow,
        color: VictusTheme.primaryPink,
        size: 16,
      ),
    );
  }

  String _formatDuration(int seconds) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '${min}:${sec.toString().padLeft(2, '0')}';
  }
}