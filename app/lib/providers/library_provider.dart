import 'package:flutter/material.dart';
import '../models/playlist.dart';
import '../../services/library_service.dart';

class LibraryProvider with ChangeNotifier {
  final LibraryService _service = LibraryService();
  
  List<PlaylistModel> _playlists = [];
  PlaylistModel? _currentPlaylist;
  bool _isLoading = false;
  String? _error;

  List<PlaylistModel> get playlists => _playlists;
  PlaylistModel? get currentPlaylist => _currentPlaylist;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPlaylists() async {
    _isLoading = true;
    notifyListeners();

    try {
      _playlists = await _service.getPlaylists();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadPlaylistDetail(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentPlaylist = await _service.getPlaylistDetail(id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearCurrentPlaylist() {
    _currentPlaylist = null;
    notifyListeners();
  }
}