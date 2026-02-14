import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../config/theme.dart';
import '../providers/video_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoPlayerScreen extends StatefulWidget {
  final int videoId;
  final int playlistId;

  const VideoPlayerScreen({
    super.key,
    required this.videoId,
    required this.playlistId,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _playerReady = false;
  bool _playerError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVideo();
    });
  }

  Future<void> _loadVideo() async {
    final provider = context.read<VideoProvider>();
    await provider.loadVideo(widget.videoId);

    if (provider.currentVideo != null && mounted) {
      debugPrint('Video URL: ${provider.currentVideo!.videoUrl}');
      _initPlayer(provider.currentVideo!.videoUrl);
    } else {
      setState(() {
        _playerError = true;
        _errorMessage = 'Não foi possível carregar o vídeo da API';
      });
    }
  }

  Future<void> _initPlayer(String url) async {
    try {
      debugPrint('Initializing player with: $url');
      _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      
      await _controller!.initialize();
      
      if (mounted) {
        setState(() => _playerReady = true);
        _controller!.play();
      }
    } catch (e) {
      debugPrint('Player error: $e');
      if (mounted) {
        setState(() {
          _playerError = true;
          _errorMessage = 'Erro ao iniciar vídeo: $e';
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VideoProvider>();
    final video = provider.currentVideo;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          video?.playlistTitle ?? 'Video',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Video Player Area
          Container(
            height: 250,
            width: double.infinity,
            color: Colors.black,
            child: _buildPlayer(),
          ),

          // Content area
          Expanded(
            child: Container(
              width: double.infinity,
              color: VictusTheme.backgroundWhite,
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator(color: VictusTheme.primaryPink))
                  : video == null
                      ? const Center(child: Text('Vídeo não encontrado'))
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title and actions
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(video.title, style: VictusTheme.heading2),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      provider.isFavorited ? Icons.favorite : Icons.favorite_border,
                                      color: provider.isFavorited ? VictusTheme.primaryPink : VictusTheme.textLight,
                                    ),
                                    onPressed: () => provider.toggleFavorite(widget.videoId),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      provider.isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                                      color: provider.isCompleted ? VictusTheme.accentGreen : VictusTheme.textLight,
                                    ),
                                    onPressed: () => provider.toggleCompleted(widget.videoId),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Description
                              if (video.description != null)
                                Text(video.description!, style: VictusTheme.bodyMedium.copyWith(height: 1.6)),

                              const SizedBox(height: 20),

                              // Next video
                              if (video.nextVideo != null)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => VideoPlayerScreen(
                                          videoId: video.nextVideo!['id'],
                                          playlistId: widget.playlistId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: VictusTheme.cardBackground,
                                      borderRadius: BorderRadius.circular(VictusTheme.radiusMedium),
                                      border: Border.all(color: VictusTheme.divider),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Próxima aula', style: VictusTheme.bodySmall),
                                              const SizedBox(height: 2),
                                              Text(video.nextVideo!['title'] ?? '', style: VictusTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 36, height: 36,
                                          decoration: const BoxDecoration(color: VictusTheme.primaryPink, shape: BoxShape.circle),
                                          child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 20),

                              // Notes section
                              Text('Anotações', style: VictusTheme.heading3),
                              const SizedBox(height: 8),
                              if (provider.notes.isEmpty)
                                Text('Sem anotações', style: VictusTheme.bodySmall),
                              ...provider.notes.map((n) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: VictusTheme.cardBackground,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(n['content'] ?? '', style: VictusTheme.bodyMedium),
                              )),

                              const SizedBox(height: 20),

                              // Comments section
                              Text('Comentários', style: VictusTheme.heading3),
                              const SizedBox(height: 8),
                              if (provider.comments.isEmpty)
                                Text('Sem comentários', style: VictusTheme.bodySmall),
                              ...provider.comments.map((c) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: VictusTheme.cardBackground,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c['user_name'] ?? 'User', style: VictusTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    Text(c['content'] ?? '', style: VictusTheme.bodyMedium),
                                  ],
                                ),
                              )),

                              const SizedBox(height: 20),

                                                            // Materials section
                              Text('Materiais', style: VictusTheme.heading3),
                              const SizedBox(height: 8),
                              if (provider.materials.isEmpty)
                                Text('Sem materiais', style: VictusTheme.bodySmall),
                              ...provider.materials.map((m) => GestureDetector(
                                onTap: () async {
                                  final url = m['file_url'] ?? '';
                                  if (url.isNotEmpty) {
                                    try {
                                      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Não foi possível abrir: $url')),
                                        );
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: VictusTheme.cardBackground,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: VictusTheme.divider),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.picture_as_pdf, color: VictusTheme.accentRed, size: 28),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(m['title'] ?? '', style: VictusTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                                            Text((m['file_type'] ?? 'pdf').toString().toUpperCase(), style: VictusTheme.bodySmall),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.download_outlined, color: VictusTheme.primaryPink),
                                    ],
                                  ),
                                ),
                              )),

                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayer() {
    if (_playerError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 8),
              Text(_errorMessage, style: const TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() { _playerError = false; _playerReady = false; });
                  _loadVideo();
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_playerReady) {
      return const Center(
        child: CircularProgressIndicator(color: VictusTheme.primaryPink),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        ),
        // Play/Pause overlay
        GestureDetector(
          onTap: () {
            setState(() {
              if (_controller!.value.isPlaying) {
                _controller!.pause();
              } else {
                _controller!.play();
              }
            });
          },
          child: Container(
            color: Colors.transparent,
            child: _controller!.value.isPlaying
                ? const SizedBox.shrink()
                : Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 36),
                  ),
          ),
        ),
        // Progress bar at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: VideoProgressIndicator(
            _controller!,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: VictusTheme.primaryPink,
              bufferedColor: VictusTheme.primaryPinkLight,
              backgroundColor: VictusTheme.divider,
            ),
          ),
        ),
      ],
    );
  }
}