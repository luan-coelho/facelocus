import 'dart:io';

import 'package:dio/dio.dart';
import 'package:facelocus/dtos/change_password_dto.dart';
import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/utils/dio_fetch_api.dart';

class UserService {
  final DioFetchApi _fetchApi = DioFetchApi();

  getAllByEventId(int eventId) async {
    String url = '${AppRoutes.user}?event=$eventId';
    final response = await _fetchApi.get(url);
    List<dynamic> data = response.data;
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  getAllByNameOrCpf(int userId, String identifier) async {
    String url = '${AppRoutes.userSearch}?user=$userId&identifier=$identifier';
    final response = await _fetchApi.get(url);
    List<dynamic> data = response.data;
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  getById(int id) async {
    final response = await _fetchApi.get('${AppRoutes.user}/$id');
    var data = response.data;
    return UserModel.fromJson(data);
  }

  changePassword(int userId, ChangePasswordDTO credentials) async {
    var json = credentials.toJson();
    String url = '${AppRoutes.user}/change-password?user=$userId';
    return await _fetchApi.patch(url, data: json);
  }

  facePhotoProfileUploud(File facePhoto, int userId) async {
    var filename = "facephoto.jpg";
    var file = await MultipartFile.fromFile(facePhoto.path, filename: filename);
    var formData = FormData.fromMap({"fileName": filename, "file": file});
    String url = '${AppRoutes.user}/uploud-face-photo?user=$userId';
    return await _fetchApi.post(url, data: formData);
  }

  checkFace(File facePhoto, int userId) async {
    var filename = "facephoto.jpg";
    var file = await MultipartFile.fromFile(facePhoto.path, filename: filename);
    var formData = FormData.fromMap({"fileName": filename, "file": file});
    String url = '${AppRoutes.user}/check-face?user=$userId';
    return await _fetchApi.post(url, data: formData);
  }

  getFacePhotoById(int userId) async {
    String url = '${AppRoutes.user}/face-photo?user=$userId';
    return await _fetchApi.get(url);
  }
}
