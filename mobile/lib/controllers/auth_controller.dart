import 'package:facelocus/models/user_model.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  late UserModel? _authenticatedUser;

  UserModel? get authenticatedUser => _authenticatedUser;

  void addAuthenticatedUser(UserModel user) {
    _authenticatedUser = user;
  }

  void logout() {
    _authenticatedUser = null;
  }
}
