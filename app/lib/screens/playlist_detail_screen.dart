import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/theme.dart';
import '../models/playlist.dart';
import '../providers/library_provider.dart';
import '../../widgets/lesson_tile.dart';
import 'video_player_screen.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final int playlistId;

  const PlaylistDetailScreen({super.key, required this.playlistId});

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LibraryProvider>().loadPlaylistDetail(widget.playlistId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  VideoItemModel? _getFirstVideo(PlaylistModel playlist) {
    if (playlist.lessons == null || playlist.lessons!.isEmpty) return null;
    for (final lesson in playlist.lessons!) {
      if (lesson.videos.isNotEmpty) return lesson.videos.first;
    }
    return null;
  }

  VideoItemModel? _getNextVideo(PlaylistModel playlist) {
    if (playlist.lessons == null) return null;
    for (final lesson in playlist.lessons!) {
      for (final video in lesson.videos) {
        if (!video.isCompleted) return video;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final library = context.watch<LibraryProvider>();
    final playlist = library.currentPlaylist;

    return Scaffold(
      backgroundColor: VictusTheme.backgroundWhite,
      body: library.isLoading || playlist == null
          ? const Center(
              child: CircularProgressIndicator(color: VictusTheme.primaryPink),
            )
          : Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      // App bar with playlist info
                      SliverToBoxAdapter(
                        child: SafeArea(
                          bottom: false,
                          child: Column(
                            children: [
                              // Top bar
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: const Icon(Icons.arrow_back,
                                          color: VictusTheme.textDark),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            playlist.title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: VictusTheme.textDark,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 6),
                                          // Progress bar
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  child:
                                                      LinearProgressIndicator(
                                                    value:
                                                        playlist.progress / 100,
                                                    backgroundColor:
                                                        VictusTheme.divider,
                                                    valueColor:
                                                        const AlwaysStoppedAnimation<
                                                            Color>(
                                                      VictusTheme.accentRed,
                                                    ),
                                                    minHeight: 4,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${playlist.progress.toStringAsFixed(0)}%',
                                                style: VictusTheme.bodySmall
                                                    .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: VictusTheme.textDark,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 36),
                                  ],
                                ),
                              ),

                              // Video thumbnail
                              _buildVideoPreview(playlist),

                              const SizedBox(height: 16),

                              // Next lesson card
                              _buildNextLessonCard(playlist),

                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),

                      // Lessons list
                      if (playlist.lessons != null)
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final lesson = playlist.lessons![index];
                              return LessonTile(
                                lesson: lesson,
                                index: index,
                                onVideoTap: (video) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => VideoPlayerScreen(
                                        videoId: video.id,
                                        playlistId: widget.playlistId,
                                      ),
                                    ),
                                  ).then((_) {
                                    // Refresh on return
                                    context
                                        .read<LibraryProvider>()
                                        .loadPlaylistDetail(widget.playlistId);
                                  });
                                },
                              );
                            },
                            childCount: playlist.lessons!.length,
                          ),
                        ),

                      const SliverToBoxAdapter(
                        child: SizedBox(height: 20),
                      ),
                    ],
                  ),
                ),

                // Bottom tab bar
                _buildBottomTabs(),
              ],
            ),
    );
  }

  Widget _buildVideoPreview(PlaylistModel playlist) {
    final firstVideo = _getFirstVideo(playlist);

    return GestureDetector(
      onTap: () {
        if (firstVideo != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VideoPlayerScreen(
                videoId: firstVideo.id,
                playlistId: widget.playlistId,
              ),
            ),
          ).then((_) {
            context
                .read<LibraryProvider>()
                .loadPlaylistDetail(widget.playlistId);
          });
        }
      },
      child: Container(
        width: double.infinity,
        height: 210,
        color: VictusTheme.darkBg,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (firstVideo?.thumbnail != null)
              CachedNetworkImage(
                imageUrl: firstVideo!.thumbnail!,
                width: double.infinity,
                height: 210,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  color: VictusTheme.darkBg,
                ),
              ),
            Container(
              color: Colors.black.withOpacity(0.3),
            ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                size: 36,
                color: VictusTheme.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextLessonCard(PlaylistModel playlist) {
    final nextVideo = _getNextVideo(playlist);
    if (nextVideo == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  nextVideo.title,
                  style: VictusTheme.heading3,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.star_border,
                    color: VictusTheme.textLight,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    nextVideo.isFavorited
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: nextVideo.isFavorited
                        ? VictusTheme.primaryPink
                        : VictusTheme.textLight,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    nextVideo.isCompleted
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: nextVideo.isCompleted
                        ? VictusTheme.accentGreen
                        : VictusTheme.textLight,
                    size: 24,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (nextVideo.description != null)
            Text(
              nextVideo.description!,
              style: VictusTheme.bodyMedium.copyWith(height: 1.5),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 12),
          // Next lesson quick link
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: VictusTheme.cardBackground,
              borderRadius: BorderRadius.circular(VictusTheme.radiusMedium),
              border: Border.all(color: VictusTheme.divider.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Próxima aula',
                        style: VictusTheme.bodySmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        nextVideo.title,
                        style: VictusTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoPlayerScreen(
                          videoId: nextVideo.id,
                          playlistId: widget.playlistId,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: VictusTheme.primaryPink,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomTabs() {
    return Container(
      decoration: BoxDecoration(
        color: VictusTheme.backgroundWhite,
        border: Border(
          top: BorderSide(color: VictusTheme.divider.withOpacity(0.5)),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: VictusTheme.accentRed,
        indicatorWeight: 2,
        labelColor: VictusTheme.accentRed,
        unselectedLabelColor: VictusTheme.textLight,
        labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            const TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
        tabs: const [
          Tab(icon: Icon(Icons.play_circle_outline, size: 20), text: 'Aulas'),
          Tab(icon: Icon(Icons.chat_bubble_outline, size: 20), text: 'Comentários'),
          Tab(icon: Icon(Icons.edit_note, size: 20), text: 'Anotações'),
          Tab(icon: Icon(Icons.folder_outlined, size: 20), text: 'Materiais'),
        ],
      ),
    );
  }
}