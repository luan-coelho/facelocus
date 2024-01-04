import 'package:facelocus/screens/auth/login_screen.dart';
import 'package:facelocus/screens/profile/profile_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:facelocus/screens/event/event_create_screen.dart';
import 'package:facelocus/screens/event/event_list_screen.dart';
import 'package:facelocus/screens/home/home_screen.dart';
import 'package:facelocus/screens/ticket-request/ticket_request.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/event',
      builder: (context, state) => const EventListScreen(),
    ),
    GoRoute(
      path: '/event/create',
      builder: (context, state) => const EventCreateScreen(),
    ),
    GoRoute(
      path: '/ticket-request',
      builder: (context, state) => const TicketRequestScreen(),
    ),
  ],
);
