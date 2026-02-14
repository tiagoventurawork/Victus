import '../models/playlist.dart';
import 'api_service.dart';

class LibraryService {
  final ApiService _api = ApiService();

  Future<List<PlaylistModel>> getPlaylists() async {
    final response = await _api.getList('/library');
    return response.map((p) => PlaylistModel.fromJson(p)).toList();
  }

  Future<PlaylistModel> getPlaylistDetail(int id) async {
    final response = await _api.get('/library/$id');
    return PlaylistModel.fromJson(response);
  }
}