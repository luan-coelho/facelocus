import 'dart:collection';

import 'package:facelocus/controllers/point_record_controller.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/screens/home/widgets/user_card.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PointRecordController _controller;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    _controller = Get.find<PointRecordController>();
    _selectedDay = _focusedDay;
    _controller.fetchAllByUser(context);
    super.initState();
  }

  List<PointRecordModel> _getEventsForDate(DateTime date) {
    Map<DateTime, List<PointRecordModel>> pointsRecordsByDate;
    pointsRecordsByDate = _groupByDate(_controller.pointsRecord);
    var list = pointsRecordsByDate[date] ?? [];
    return list;
  }

  LinkedHashMap<DateTime, List<PointRecordModel>> _groupByDate(
      List<PointRecordModel> pointRecords) {
    Map<DateTime, List<PointRecordModel>> groupedByDate = {};

    for (PointRecordModel record in pointRecords) {
      DateTime date = record.date;
      if (groupedByDate.containsKey(date)) {
        groupedByDate[date]!.add(record);
      } else {
        groupedByDate[date] = [record];
      }
    }
    return LinkedHashMap<DateTime, List<PointRecordModel>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(groupedByDate);
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _controller.fetchAllByDate(context, selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      showAppBar: false,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 50, bottom: 20, left: 32, right: 32),
        child: Obx(
          () {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const UserCardHome(),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 5,
                          offset: const Offset(0, 1.5),
                        ),
                      ],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  child: TableCalendar<PointRecordModel>(
                    firstDay: _controller.firstDay.value,
                    lastDay: _controller.lastDay.value,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    calendarFormat: _calendarFormat,
                    eventLoader: _getEventsForDate,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    calendarStyle: const CalendarStyle(
                      // Use `CalendarStyle` to customize the UI
                      outsideDaysVisible: false,
                    ),
                    onDaySelected: _onDaySelected,
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                    child: ListView.builder(
                  itemCount: _controller.pointsRecordByDate.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () =>
                            print('${_controller.pointsRecordByDate[index]}'),
                        title: Text(
                            '${_controller.pointsRecordByDate[index].event!.description}'),
                      ),
                    );
                  },
                )),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.pointRecordCreate),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white, size: 29),
      ),
    );
  }
}
