import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;

  Future<String?> get token async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Map<String, String>> get _authHeaders async {
    final t = await token;
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (t != null) 'Authorization': 'Bearer $t',
    };
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final headers = await _authHeaders;
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<List<dynamic>> getList(String endpoint) async {
    final headers = await _authHeaders;
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: headers,
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    }
    throw ApiException(
      statusCode: response.statusCode,
      message: _extractError(response.body),
    );
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final headers = await _authHeaders;
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    final headers = await _authHeaders;
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: headers,
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final headers = await _authHeaders;
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> uploadFile(
    String endpoint,
    File file,
    String fieldName,
  ) async {
    final t = await token;
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
    );
    
    if (t != null) {
      request.headers['Authorization'] = 'Bearer $t';
    }

    request.files.add(await http.MultipartFile.fromPath(fieldName, file.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = json.decode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }
    throw ApiException(
      statusCode: response.statusCode,
      message: body['error'] ?? 'Erro desconhecido',
    );
  }

  String _extractError(String body) {
    try {
      final decoded = json.decode(body);
      return decoded['error'] ?? 'Erro desconhecido';
    } catch (_) {
      return 'Erro desconhecido';
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}