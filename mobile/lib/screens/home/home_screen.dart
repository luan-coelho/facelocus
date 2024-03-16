import 'dart:collection';

import 'package:facelocus/controllers/auth/session_controller.dart';
import 'package:facelocus/controllers/point_record_create_controller.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/screens/home/widgets/point_record_card.dart';
import 'package:facelocus/screens/home/widgets/user_card.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PointRecordCreateController _controller;
  late final SessionController _authController;
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    _controller = Get.find<PointRecordCreateController>();
    _authController = Get.find<SessionController>();
    _selectedDay = _focusedDay;
    _controller.fetchAllByUser(context);
    _controller.fetchAllByDate(context, _focusedDay);
    super.initState();
  }

  List<PointRecordModel> _getEventsForDate(DateTime date) {
    Map<DateTime, List<PointRecordModel>> pointsRecordsByDate;
    pointsRecordsByDate = _groupByDate(_controller.pointsRecord);
    return pointsRecordsByDate[date] ?? [];
  }

  _groupByDate(List<PointRecordModel> pointRecords) {
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
        padding: const EdgeInsets.all(30),
        child: Obx(
          () {
            /*if (_controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }*/

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const UserCardHome(),
                const SizedBox(height: 15),
                AppButton(
                  text: 'Solicitações',
                  onPressed: () => context.push(AppRoutes.eventRequest),
                  icon: SvgPicture.asset(
                    'images/event-request-icon.svg',
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: TableCalendar<PointRecordModel>(
                    headerStyle: const HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    firstDay: _controller.firstDay.value,
                    lastDay: _controller.lastDay.value,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    calendarFormat: _calendarFormat,
                    eventLoader: _getEventsForDate,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    locale: 'pt_br',
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, events) => events.isNotEmpty
                          ? Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColorsConst.purple.shade900,
                              ),
                              child: Text(
                                events.length.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                          : null,
                    ),
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: AppColorsConst.purple.shade400.withOpacity(0.5),
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.3),
                      ),
                      markersAlignment: Alignment.bottomRight,
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
                const SizedBox(height: 20),
                if (_controller.pointsRecordByDate.isNotEmpty) ...[
                  const Text(
                    'Registros de ponto',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox()
                ],
                const SizedBox(height: 10),
                if (_controller.isLoadingPr.value) ...[
                  const Center(
                    child: SizedBox(
                      width: 50,
                      child: LoadingIndicator(
                          indicatorType: Indicator.ballPulse,
                          colors: [AppColorsConst.blue],
                          strokeWidth: 2,
                          backgroundColor: Colors.transparent,
                          pathBackgroundColor: Colors.black),
                    ),
                  ),
                ] else ...[
                  if (_controller.pointsRecordByDate.isEmpty) ...[
                    const Center(
                      child: Text(
                        'Nenhum registro de ponto para esta data',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    )
                  ] else ...[
                    Expanded(
                      child: SingleChildScrollView(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(0),
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 10);
                          },
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _controller.pointsRecordByDate.length,
                          itemBuilder: (context, index) {
                            var pr = _controller.pointsRecordByDate[index];
                            return PointRecordCard(
                              pointRecord: pr,
                              user: _authController.authenticatedUser.value!,
                            );
                          },
                        ),
                      ),
                    )
                  ]
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
