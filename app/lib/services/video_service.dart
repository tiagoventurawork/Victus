import '../models/video.dart';
import 'api_service.dart';

class VideoService {
  final ApiService _api = ApiService();

  Future<VideoDetailModel> getVideo(int id) async {
    final response = await _api.get('/videos/$id');
    return VideoDetailModel.fromJson(response);
  }

  Future<void> saveProgress(int videoId, int currentSeconds, int totalSeconds) async {
    await _api.post('/progress', {
      'video_id': videoId,
      'current_seconds': currentSeconds,
      'total_seconds': totalSeconds,
    });
  }

  Future<Map<String, dynamic>> toggleFavorite(int videoId) async {
    return await _api.post('/favorites', {'video_id': videoId});
  }

  Future<Map<String, dynamic>> toggleCompleted(int videoId) async {
    return await _api.post('/completed', {'video_id': videoId});
  }

  Future<List<dynamic>> getNotes(int videoId) async {
    return await _api.getList('/notes/$videoId');
  }

  Future<void> createNote(int videoId, String content, int timestamp) async {
    await _api.post('/notes', {
      'video_id': videoId,
      'content': content,
      'timestamp': timestamp,
    });
  }

  Future<List<dynamic>> getComments(int videoId) async {
    return await _api.getList('/comments/$videoId');
  }

  Future<void> createComment(int videoId, String content) async {
    await _api.post('/comments', {
      'video_id': videoId,
      'content': content,
    });
  }

  Future<List<dynamic>> getMaterials(int videoId) async {
    return await _api.getList('/materials/$videoId');
  }
}