import 'package:facelocus/router.dart';
import 'package:facelocus/screens/home/widgets/home_features.dart';
import 'package:facelocus/screens/home/widgets/user_card.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
        body: Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 32, right: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const UserCardHome(),
              TableCalendar(
                locale: 'en-us',
                calendarStyle: const CalendarStyle(
                  defaultDecoration: BoxDecoration(
                    color: Colors.green
                  )
                ),
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: DateTime.now(),
              ),
              const SizedBox(height: 30),
              const HomeFeatures(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push(AppRoutes.pointRecordCreate),
          backgroundColor: Colors.green,
          child: const Icon(Icons.add, color: Colors.white, size: 29),
        ));
  }
}
