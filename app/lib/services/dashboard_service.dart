import '../models/user.dart';
import '../models/event.dart';
import '../models/banner_model.dart';
import 'api_service.dart';

class DashboardData {
  final UserModel user;
  final List<BannerModel> banners;
  final Map<String, dynamic>? reminder;
  final List<EventModel> events;

  DashboardData({
    required this.user,
    required this.banners,
    this.reminder,
    required this.events,
  });
}

class DashboardService {
  final ApiService _api = ApiService();

  Future<DashboardData> getDashboard() async {
    final response = await _api.get('/dashboard');

    final user = UserModel.fromJson(response['user']);
    final banners = (response['banners'] as List)
        .map((b) => BannerModel.fromJson(b))
        .toList();
    final events = (response['events'] as List)
        .map((e) => EventModel.fromJson(e))
        .toList();

    return DashboardData(
      user: user,
      banners: banners,
      reminder: response['reminder'],
      events: events,
    );
  }

  Future<EventModel> getEventDetail(int id) async {
    final response = await _api.get('/events/$id');
    return EventModel.fromJson(response);
  }
}