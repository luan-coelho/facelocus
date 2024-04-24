import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:facelocus/controllers/user_controller.dart';
import 'package:facelocus/dtos/token_response_dto.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/services/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final GoRouter router;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthBloc(this.router, {required this.repository}) : super(AuthInitial()) {
    on<AuthLoginRequested>((event, emit) async {
      try {
        emit(AuthLoading());
        TokenResponse tokenResponse = await repository.login(
          event.login,
          event.password,
        );

        if (tokenResponse.token.isNotEmpty) {
          String token = tokenResponse.token;
          int userId = tokenResponse.user.id!;
          await _storage.write(key: 'token', value: token);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('user', userId);
          UserModel user = tokenResponse.user;
          // addAuthenticatedUser(user);

          if (user.facePhoto == null) {
            emit(UserWithoutFacePhoto());
            router.replace(AppRoutes.userUploadFacePhoto);
            return;
          }
          UserController userController = Get.find<UserController>();
          // await userController.fetchFacePhotoById(context);
          emit(AuthSuccess());
        }
      } on DioException catch (e) {
        String detail = 'Não foi possível realizar o login';
        if (e.response?.data['detail'] != null) {
          detail = e.response?.data['detail'];
        }
        emit(AuthError(detail));
      }
    });
  }
}
