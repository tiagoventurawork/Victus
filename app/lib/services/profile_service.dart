import 'dart:io';
import '../models/user.dart';
import 'api_service.dart';

class ProfileService {
  final ApiService _api = ApiService();

  Future<UserModel> getProfile() async {
    final response = await _api.get('/profile');
    return UserModel.fromJson(response);
  }

  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    final response = await _api.put('/profile', data);
    return UserModel.fromJson(response['user']);
  }

  Future<UserModel> uploadAvatar(File file) async {
    final response = await _api.uploadFile('/profile/avatar', file, 'avatar');
    return UserModel.fromJson(response['user']);
  }
}