import 'package:facelocus/models/user_model.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  late UserModel? _authenticatedUser;

  UserModel get authenticatedUser => _authenticatedUser!;

  void addAuthenticatedUser(UserModel user) {
    _authenticatedUser = user;
  }

  void logout() {
    _authenticatedUser = null;
  }
}
