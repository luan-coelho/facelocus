import 'package:facelocus/features/home/bloc/home/home_bloc.dart';
import 'package:facelocus/features/home/widgets/point_record_card.dart';
import 'package:facelocus/features/home/widgets/user_card.dart';
import 'package:facelocus/models/point_record_model.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/widgets/app_bottom_navigation_bar.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<HomeBloc>().add(LoadPointRecords());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
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
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is PointRecordLoaded) {
                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async => context.read<HomeBloc>().add(
                              LoadPointRecords(),
                            ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
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
                            eventsList: state.pointRecordsEventsList,
                            isExpandable: true,
                            eventDoneColor: Colors.green,
                            selectedColor: Colors.pink,
                            selectedTodayColor: Colors.red,
                            todayColor: Colors.blue,
                            eventColor: null,
                            onEventSelected: (value) {
                              Map<String, dynamic> json = value.metadata!;
                              var pr = PointRecordModel.fromJson(json);
                              var loggedUser = state.loggedUser.id;
                              var prAdmin = pr.event!.administrator!.id;

                              String url = "$AppRoutes.pointRecord/${pr.id}";
                              if (prAdmin == loggedUser) {
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
                            eventListBuilder: (
                              BuildContext context,
                              List<NeatCleanCalendarEvent> selectesdEvents,
                            ) {
                              return ListView.separated(
                                shrinkWrap: true,
                                itemCount: selectesdEvents.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemBuilder: (context, index) {
                                  var json = selectesdEvents[index].metadata;
                                  var pr = PointRecordModel.fromJson(json!);
                                  return PointRecordCard(
                                    pointRecord: pr,
                                    user: state.loggedUser,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is PointRecordError) {
                    return Center(
                      child: Text(state.message),
                    );
                  }

                  return const Center(
                    child: Spinner(),
                  );
                },
              ),
            ],
          ),
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
