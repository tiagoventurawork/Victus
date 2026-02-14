import 'package:flutter/material.dart';
import '../models/video.dart';
import '../../services/video_service.dart';

class VideoProvider with ChangeNotifier {
  final VideoService _service = VideoService();
  
  VideoDetailModel? _currentVideo;
  bool _isLoading = false;
  bool _isFavorited = false;
  bool _isCompleted = false;
  List<dynamic> _notes = [];
  List<dynamic> _comments = [];
  List<dynamic> _materials = [];

  VideoDetailModel? get currentVideo => _currentVideo;
  bool get isLoading => _isLoading;
  bool get isFavorited => _isFavorited;
  bool get isCompleted => _isCompleted;
  List<dynamic> get notes => _notes;
  List<dynamic> get comments => _comments;
  List<dynamic> get materials => _materials;

  Future<void> loadVideo(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentVideo = await _service.getVideo(id);
      _isFavorited = _currentVideo!.isFavorited;
      _isCompleted = _currentVideo!.isCompleted;
      
      // Load extras
      await Future.wait([
        _loadNotes(id),
        _loadComments(id),
        _loadMaterials(id),
      ]);
    } catch (e) {
      debugPrint('Error loading video: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadNotes(int videoId) async {
    try { _notes = await _service.getNotes(videoId); } catch (_) {}
  }

  Future<void> _loadComments(int videoId) async {
    try { _comments = await _service.getComments(videoId); } catch (_) {}
  }

  Future<void> _loadMaterials(int videoId) async {
    try { _materials = await _service.getMaterials(videoId); } catch (_) {}
  }

  Future<void> saveProgress(int videoId, int currentSeconds, int totalSeconds) async {
    try {
      await _service.saveProgress(videoId, currentSeconds, totalSeconds);
    } catch (e) {
      debugPrint('Error saving progress: $e');
    }
  }

  Future<void> toggleFavorite(int videoId) async {
    try {
      final result = await _service.toggleFavorite(videoId);
      _isFavorited = result['favorited'] == true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  Future<void> toggleCompleted(int videoId) async {
    try {
      final result = await _service.toggleCompleted(videoId);
      _isCompleted = result['completed'] == true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling completed: $e');
    }
  }

  Future<void> addNote(int videoId, String content, int timestamp) async {
    try {
      await _service.createNote(videoId, content, timestamp);
      await _loadNotes(videoId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding note: $e');
    }
  }

  Future<void> addComment(int videoId, String content) async {
    try {
      await _service.createComment(videoId, content);
      await _loadComments(videoId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding comment: $e');
    }
  }
}