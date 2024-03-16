import 'package:facelocus/models/event_request_type_enum.dart';
import 'package:facelocus/screens/auth/face_upload_screen.dart';
import 'package:facelocus/screens/auth/login_screen.dart';
import 'package:facelocus/screens/auth/register_screen.dart';
import 'package:facelocus/screens/event/event_create_form.dart';
import 'package:facelocus/screens/event/event_list_screen.dart';
import 'package:facelocus/screens/event/event_request_list_screen.dart';
import 'package:facelocus/screens/event/event_request_show_screen.dart';
import 'package:facelocus/screens/event/event_show_screen.dart';
import 'package:facelocus/screens/event/lincked_users_screen.dart';
import 'package:facelocus/screens/event/location_screen.dart';
import 'package:facelocus/screens/home/home_screen.dart';
import 'package:facelocus/screens/point-record/point_record_admin_edit_screen.dart';
import 'package:facelocus/screens/point-record/point_record_admin_show_screen.dart';
import 'package:facelocus/screens/point-record/point_record_create_screen.dart';
import 'package:facelocus/screens/point-record/point_record_list_screen.dart';
import 'package:facelocus/screens/point-record/point_record_show_screen.dart';
import 'package:facelocus/screens/point-record/point_validate_screen.dart';
import 'package:facelocus/screens/point-record/widgets/validate_factors.dart';
import 'package:facelocus/screens/profile/profile_screen.dart';
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
  static const userSearch = '$user/search';
  static const pointRecord = '/point-record';
  static const pointRecordCreate = '$pointRecord/create';
  static const pointRecordEdit = '$pointRecord/edit';
  static const pointRecordPointValidate = '$pointRecord/point-validate';
  static const userAttendance = '/user-attendance';
  static const validateFactors = '/validate-factors';
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
      builder: (context, state) {
        // int eventId = int.parse(state.uri.queryParameters['event']!);
        return const EventRequestListScreen();
      },
    ),
    GoRoute(
      path: '${AppRoutes.eventRequest}/:id',
      builder: (context, state) {
        var eventQueryParameter = state.uri.queryParameters['eventrequest'];
        var requestTypeQueryParam = state.uri.queryParameters['requesttype'];
        int eventRequestId = int.parse(eventQueryParameter!);
        var requestType = EventRequestType.parse(requestTypeQueryParam!)!;
        return EventRequestShowScreen(
            eventRequestId: eventRequestId, requestType: requestType);
      },
    ),
    GoRoute(
      path: AppRoutes.pointRecord,
      builder: (context, state) {
        return const PointRecordListScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.pointRecordCreate,
      builder: (context, state) {
        return const PointRecordCreateScreen();
      },
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
      builder: (context, state) {
        return const PointValidateScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.validateFactors,
      builder: (context, state) {
        return const ValidateFactors(factors: []);
      },
    ),
  ],
);
