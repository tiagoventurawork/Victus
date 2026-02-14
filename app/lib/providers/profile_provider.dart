import 'dart:io';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../../services/profile_service.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileService _service = ProfileService();
  
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _service.getProfile();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      _user = await _service.updateProfile(data);
      _successMessage = 'Perfil atualizado com sucesso';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> uploadAvatar(File file) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _service.uploadAvatar(file);
      _successMessage = 'Foto de perfil atualizada';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}