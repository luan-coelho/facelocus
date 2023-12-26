import 'package:go_router/go_router.dart';
import 'package:facelocus/screens/event/event_create_screen.dart';
import 'package:facelocus/screens/event/event_list_screen.dart';
import 'package:facelocus/screens/home_screen.dart';
import 'package:facelocus/screens/ticket_request.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
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
