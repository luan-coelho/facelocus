import 'package:facelocus/features/auth/screens/face_upload_screen.dart';
import 'package:facelocus/features/auth/screens/login_screen.dart';
import 'package:facelocus/features/auth/screens/register_screen.dart';
import 'package:facelocus/features/event-request/screens/event_request_list_screen.dart';
import 'package:facelocus/features/event-request/screens/event_request_show_screen.dart';
import 'package:facelocus/features/event/screens/event_create_form.dart';
import 'package:facelocus/features/event/screens/event_list_screen.dart';
import 'package:facelocus/features/event/screens/event_show_screen.dart';
import 'package:facelocus/features/event/screens/lincked_users_screen.dart';
import 'package:facelocus/features/event/screens/location_screen.dart';
import 'package:facelocus/features/home/screens/home_screen.dart';
import 'package:facelocus/features/point-record/screens/facial_factor_validate_screen.dart';
import 'package:facelocus/features/point-record/screens/location_factor_validate_screen.dart';
import 'package:facelocus/features/point-record/screens/point_record_admin_edit_screen.dart';
import 'package:facelocus/features/point-record/screens/point_record_admin_show_screen.dart';
import 'package:facelocus/features/point-record/screens/point_record_create_screen.dart';
import 'package:facelocus/features/point-record/screens/point_record_list_screen.dart';
import 'package:facelocus/features/point-record/screens/point_record_show_screen.dart';
import 'package:facelocus/features/point-record/screens/point_validate_screen.dart';
import 'package:facelocus/features/point-record/screens/validate_factors.dart';
import 'package:facelocus/features/profile/screens/app_about_screen.dart';
import 'package:facelocus/features/profile/screens/profile_screen.dart';
import 'package:facelocus/models/event_request_type_enum.dart';
import 'package:facelocus/screens/profile/change_face_photo_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const home = '/home';
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const checkToken = '/auth/check-token';
  static const profile = '/profile';
  static const event = '/event';
  static const eventShow = '$event/show';
  static const eventCreate = '$event/create';
  static const eventLocations = '$event-location';
  static const eventUsers = '$event-users';
  static const eventRequest = '/event-request';
  static const user = '/user';
  static const userUploadFacePhoto = '$user/uploud-face-photo';
  static const changeFacePhoto = '$user/change-face-photo';
  static const userSearch = '$user/search';
  static const pointRecord = '/point-record';
  static const pointRecordCreate = '$pointRecord/create';
  static const pointRecordEdit = '$pointRecord/edit';
  static const pointRecordPointValidate = '$pointRecord/point-validate';
  static const userAttendance = '/user-attendance';
  static const validateFactors = '/validate-factors';
  static const facialFactorValidate = '/facial-factor-validate';
  static const locationFactorValidate = '/location-factor-validate';
  static const attendanceRecord = '/attendance-record';
  static const about = '/about';
}

void clearAndNavigate(String path) {
  while (router.canPop() == true) {
    router.pop();
  }
  router.pushReplacement(path);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.userUploadFacePhoto,
      builder: (context, state) => const FaceUploadScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.changeFacePhoto,
      builder: (context, state) => const ChangeFacePhotoScreen(),
    ),
    GoRoute(
      path: AppRoutes.event,
      builder: (context, state) => const EventListScreen(),
    ),
    GoRoute(
      path: '${AppRoutes.eventShow}/:id',
      builder: (context, state) {
        final int eventId = int.parse(state.pathParameters['id']!);
        return EventShowScreen(eventId: eventId);
      },
    ),
    GoRoute(
      path: AppRoutes.eventCreate,
      builder: (context, state) => const EventCreateForm(),
    ),
    GoRoute(
      path: AppRoutes.eventLocations,
      builder: (context, state) {
        int eventId = int.parse(state.uri.queryParameters['event']!);
        return LocationListScreen(eventId: eventId);
      },
    ),
    GoRoute(
      path: AppRoutes.eventUsers,
      builder: (context, state) {
        int eventId = int.parse(state.uri.queryParameters['event']!);
        return LinckedUsersScreen(eventId: eventId);
      },
    ),
    GoRoute(
      path: AppRoutes.eventRequest,
      builder: (context, state) => const EventRequestListScreen(),
    ),
    GoRoute(
      path: '${AppRoutes.eventRequest}/:id',
      builder: (context, state) {
        var eventQueryParameter = state.uri.queryParameters['eventrequest'];
        var requestTypeQueryParam = state.uri.queryParameters['requesttype'];
        int eventRequestId = int.parse(eventQueryParameter!);
        var requestType = EventRequestType.parse(requestTypeQueryParam!)!;
        return EventRequestShowScreen(
          eventRequestId: eventRequestId,
          requestType: requestType,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.pointRecord,
      builder: (context, state) => const PointRecordListScreen(),
    ),
    GoRoute(
      path: AppRoutes.pointRecordCreate,
      builder: (context, state) => const PointRecordCreateScreen(),
    ),
    GoRoute(
      path: '/admin${AppRoutes.pointRecord}/:id',
      builder: (context, state) {
        final int pointRecordId = int.parse(state.pathParameters['id']!);
        return PointRecordAdminShowScreen(pointRecordId: pointRecordId);
      },
    ),
    GoRoute(
      path: '/admin${AppRoutes.pointRecordEdit}/:id',
      builder: (context, state) {
        final int pointRecordId = int.parse(state.pathParameters['id']!);
        return PointRecordAdminEditScreen(pointRecordId: pointRecordId);
      },
    ),
    GoRoute(
      path: '${AppRoutes.pointRecord}/:id',
      builder: (context, state) {
        final int pointRecordId = int.parse(state.pathParameters['id']!);
        return PointRecordShowScreen(pointRecordId: pointRecordId);
      },
    ),
    GoRoute(
      path: AppRoutes.pointRecordPointValidate,
      builder: (context, state) => const PointValidateScreen(),
    ),
    GoRoute(
      path: AppRoutes.validateFactors,
      builder: (context, state) {
        final int attendanceRecordId = int.parse(
          state.uri.queryParameters['attendanceRecord']!,
        );
        final bool frf = bool.parse(
          state.uri.queryParameters['faceRecognitionFactor']!,
        );
        final bool ilf = bool.parse(
          state.uri.queryParameters['locationIndoorFactor']!,
        );
        return ValidateFactorsScreen(
          attendanceRecordId: attendanceRecordId,
          faceRecognitionFactor: frf,
          locationIndoorFactor: ilf,
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.facialFactorValidate}/:id',
      builder: (context, state) {
        final int attendanceRecordId = int.parse(state.pathParameters['id']!);
        return FacialFactorValidateScreen(
          attendanceRecordId: attendanceRecordId,
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.locationFactorValidate}/:id',
      builder: (context, state) {
        final int attendanceRecordId = int.parse(state.pathParameters['id']!);
        return LocationFactorValidateScreen(
          attendanceRecordId: attendanceRecordId,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.about,
      builder: (context, state) => const AppAboutScreen(),
    )
  ],
);
