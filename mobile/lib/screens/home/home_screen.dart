import 'package:facelocus/controllers/auth/session_controller.dart';
import 'package:facelocus/controllers/point_record_create_controller.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/screens/home/widgets/user_card.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/widgets/app_bottom_navigation_bar.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_indicator/loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PointRecordCreateController _controller;
  late final SessionController _sessionController;

  @override
  void initState() {
    _controller = Get.find<PointRecordCreateController>();
    _sessionController = Get.find<SessionController>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _controller.fetchAllByUser(context),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Obx(() {
            if (_controller.isLoading.value) {
              return const Center(
                child: SizedBox(
                  width: 50,
                  child: LoadingIndicator(
                      indicatorType: Indicator.ballPulse,
                      colors: [AppColorsConst.blue],
                      strokeWidth: 2,
                      backgroundColor: Colors.transparent,
                      pathBackgroundColor: Colors.black),
                ),
              );
            }
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
                Expanded(
                  child: Calendar(
                    startOnMonday: true,
                    weekDays: const [
                      'Seg',
                      'Ter',
                      'Qua',
                      'Qui',
                      'Sex',
                      'Sáb',
                      'Dom',
                    ],
                    eventsList: _controller.prEvents,
                    isExpandable: true,
                    eventDoneColor: Colors.green,
                    selectedColor: Colors.pink,
                    selectedTodayColor: Colors.red,
                    todayColor: Colors.blue,
                    eventColor: null,
                    onEventSelected: (value) {
                      String url =
                          "${AppRoutes.pointRecord}/${value.metadata!['id']}";
                      var userId =
                          _sessionController.authenticatedUser.value!.id;
                      var prAdmin =
                          value.metadata!['event']['administrator']['id'];
                      if (prAdmin == userId) {
                        context.push('/admin$url');
                        return;
                      }
                      context.push(url);
                    },
                    locale: 'pt_br',
                    todayButtonText: 'Hoje',
                    isExpanded: true,
                    expandableDateFormat: 'EEEE, dd. MMMM',
                    datePickerType: DatePickerType.date,
                    dayOfWeekStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                    displayMonthTextStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    hideTodayIcon: true,
                  ),
                ),
              ],
            );
          }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push(AppRoutes.pointRecordCreate),
          elevation: 13,
          backgroundColor: AppColorsConst.blue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const AppBottomNavigationBar(),
      ),
    );
  }
}
