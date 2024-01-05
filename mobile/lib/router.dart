import 'package:facelocus/screens/auth/login_screen.dart';
import 'package:facelocus/screens/event/widgets/event_show_screen.dart';
import 'package:facelocus/screens/location/location_list_screen.dart';
import 'package:facelocus/screens/location/location_form_screen.dart';
import 'package:facelocus/screens/profile/profile_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:facelocus/screens/event/event_create_screen.dart';
import 'package:facelocus/screens/event/event_list_screen.dart';
import 'package:facelocus/screens/home/home_screen.dart';
import 'package:facelocus/screens/ticket-request/ticket_request.dart';

final router = GoRouter(
  initialLocation: "/home",
  routes: [
    GoRoute(
      path: "/login",
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: "/home",
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: "/profile",
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: "/event",
      builder: (context, state) => const EventListScreen(),
    ),
    GoRoute(
      path: "/event/show/:id",
      builder: (context, state) {
        final int eventId = int.parse(state.pathParameters["id"]!);
        return EventShowScreen(eventId: eventId);
      },
    ),
    GoRoute(
      path: "/event/create",
      builder: (context, state) => const EventCreateScreen(),
    ),
    GoRoute(
      path: "/event/locations",
      builder: (context, state) => const LocationListScreen(),
    ),
    GoRoute(
      path: "/event/locations/form",
      builder: (context, state) => const LocationFormScreen(),
    ),
    GoRoute(
      path: "/ticket-request",
      builder: (context, state) => const TicketRequestScreen(),
    ),
  ],
);
