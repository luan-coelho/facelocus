import 'package:facelocus/screens/auth/login_screen.dart';
import 'package:facelocus/screens/auth/register_screen.dart';
import 'package:facelocus/screens/event/event_create_form.dart';
import 'package:facelocus/screens/event/event_list_screen.dart';
import 'package:facelocus/screens/event/event_show_screen.dart';
import 'package:facelocus/screens/event/lincked_users_screen.dart';
import 'package:facelocus/screens/event/location_screen.dart';
import 'package:facelocus/screens/home/home_screen.dart';
import 'package:facelocus/screens/profile/profile_screen.dart';
import 'package:facelocus/screens/ticket-request/ticket_request_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const home = '/home';
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const profile = '/profile';
  static const event = '/event';
  static const eventShow = '$event/show';
  static const eventCreate = '$event/create';
  static const eventLocations = '$event-location';
  static const eventUsers = '$event-users';
  static const ticketRequest = '/ticket-request';
  static const ticketRequestByUser = '$ticketRequest/by-user';
  static const user = '/user';
  static const userSearch = '$user/search';
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
      path: AppRoutes.ticketRequest,
      builder: (context, state) => const TicketRequestScreen(),
    ),
  ],
);
