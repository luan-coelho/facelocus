import 'dart:convert';

import 'package:facelocus/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(user.toJson());
    await prefs.setString('user', json);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    if (user != null) {
      return UserModel.fromJson(jsonDecode(user)).id;
    }
    return null;
  }

  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    if (user != null) {
      return UserModel.fromJson(jsonDecode(user));
    }
    return null;
  }

  Future<void> saveToken(String token) async => await _storage.write(
        key: 'token',
        value: token,
      );

  Future<String?> getToken() async => await _storage.read(
        key: 'token',
      );

  Future<void> deleteToken() async => await _storage.delete(
        key: 'token',
      );

  Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }

  Future<void> logout() async {
    removeUser();
    deleteToken();
  }
}
