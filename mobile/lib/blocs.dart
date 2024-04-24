import 'package:facelocus/features/auth/bloc/login/login_bloc.dart';
import 'package:facelocus/features/auth/bloc/register/register_bloc.dart';
import 'package:facelocus/features/home/bloc/home/home_bloc.dart';
import 'package:facelocus/services/auth_repository.dart';
import 'package:facelocus/services/point_record_service.dart';
import 'package:facelocus/services/user_repository.dart';
import 'package:facelocus/shared/session/repository/session_repository.dart';
import 'package:facelocus/shared/user-face-photo/user_face_photo_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocs {
  static final blocs = [
    BlocProvider<RegisterBloc>(
      create: (context) => RegisterBloc(
        authRepository: AuthRepository(),
      ),
    ),
    BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(
        pointRecordRepository: PointRecordRepository(),
        sessionRepository: SessionRepository(),
      ),
    ),
    BlocProvider<UserFacePhotoBloc>(
      create: (context) => UserFacePhotoBloc(
        userRepository: UserRepository(),
        sessionRepository: SessionRepository(),
      ),
    ),
    BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(
        authRepository: AuthRepository(),
        sessionRepository: SessionRepository(),
        userFacePhotoBloc: BlocProvider.of<UserFacePhotoBloc>(context),
      ),
    ),
  ];
}
