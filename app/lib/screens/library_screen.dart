import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/library_provider.dart';
import '../../widgets/playlist_card.dart';
import 'playlist_detail_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LibraryProvider>().loadPlaylists();
    });
  }

  @override
  Widget build(BuildContext context) {
    final library = context.watch<LibraryProvider>();

        return Scaffold(
      backgroundColor: VictusTheme.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Header
            const Text(
              'Biblioteca',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: VictusTheme.textDark,
              ),
            ),
            const SizedBox(height: 16),
            // List
            Expanded(
              child: library.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: VictusTheme.primaryPink,
                      ),
                    )
                  : library.playlists.isEmpty
                      ? const Center(
                          child: Text('Nenhuma playlist disponível'),
                        )
                      : RefreshIndicator(
                          color: VictusTheme.primaryPink,
                          onRefresh: () => library.loadPlaylists(),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: library.playlists.length,
                            itemBuilder: (context, index) {
                              final playlist = library.playlists[index];
                              return PlaylistCard(
                                playlist: playlist,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PlaylistDetailScreen(
                                        playlistId: playlist.id,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}