import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserService service;
  final Rx<UserModel?> _user = (null).obs;
  List<UserModel> _usersSearch = <UserModel>[].obs;
  List<UserModel> _users = <UserModel>[].obs;

  Rx<UserModel?> get user => _user;

  List<UserModel> get users => _users;

  List<UserModel> get usersSearch => _usersSearch;

  final RxBool _isLoading = false.obs;

  RxBool get isLoading => _isLoading;

  UserController({required this.service});

  fetchAllByEventId(int eventId) async {
    _isLoading.value = true;
    _users = await service.getAllByEventId(eventId);
    _isLoading.value = false;
  }

  fetchAllByNameOrCpf(String identifier) async {
    _isLoading.value = true;
    _usersSearch = await service.getAllByNameOrCpf(identifier);
    _isLoading.value = false;
  }

/* fetchById(int locationId) async {
    isLoading = true;
    notifyListeners();

    _user = await _userService.getById(locationId);

    isLoading = false;
    notifyListeners();
  }*/
}
