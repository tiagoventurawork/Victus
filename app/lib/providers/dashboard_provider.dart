import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/event.dart';
import '../models/banner_model.dart';
import '../../services/dashboard_service.dart';

class DashboardProvider with ChangeNotifier {
  final DashboardService _service = DashboardService();
  
  UserModel? _user;
  List<BannerModel> _banners = [];
  Map<String, dynamic>? _reminder;
  List<EventModel> _events = [];
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  List<BannerModel> get banners => _banners;
  Map<String, dynamic>? get reminder => _reminder;
  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _service.getDashboard();
      _user = data.user;
      _banners = data.banners;
      _reminder = data.reminder;
      _events = data.events;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<EventModel?> getEventDetail(int id) async {
    try {
      return await _service.getEventDetail(id);
    } catch (e) {
      return null;
    }
  }
}