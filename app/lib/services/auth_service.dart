import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  Future<UserModel> login(String email, String password) async {
    final response = await _api.post('/auth/login', {
      'email': email,
      'password': password,
    });

    await _api.setToken(response['token']);
    final user = UserModel.fromJson(response['user']);
    await _saveUser(user);
    return user;
  }

  Future<UserModel> register(String name, String email, String password) async {
    final response = await _api.post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
    });

    await _api.setToken(response['token']);
    final user = UserModel.fromJson(response['user']);
    await _saveUser(user);
    return user;
  }

  Future<void> recover(String email) async {
    await _api.post('/auth/recover', {'email': email});
  }

  Future<void> logout() async {
    await _api.clearToken();
  }

  Future<UserModel?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData == null) return null;
    
    final token = prefs.getString('auth_token');
    if (token == null) return null;

    return UserModel.fromJson(json.decode(userData));
  }

  Future<void> _saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', json.encode(user.toJson()));
  }
}