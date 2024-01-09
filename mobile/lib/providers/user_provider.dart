import 'package:facelocus/models/user_model.dart';
import 'package:facelocus/services/user_service.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();
  late UserModel _user;
  List<UserModel> _usersSearch = [];
  List<UserModel> _users = [];
  bool isLoading = false;

  UserModel get user => _user;

  List<UserModel> get users => _users;

  List<UserModel> get usersSearch => _usersSearch;

  Future<void> fetchAllByEventId(int eventId) async {
    isLoading = true;
    notifyListeners();

    _users = await _userService.getAllByEventId(eventId);

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAllByNameOrCpf(String identifier) async {
    _usersSearch = await _userService.getAllByNameOrCpf(identifier);
    notifyListeners();
  }

/* Future<void> fetchById(int locationId) async {
    isLoading = true;
    notifyListeners();

    _user = await _userService.getById(locationId);

    isLoading = false;
    notifyListeners();
  }*/
}
