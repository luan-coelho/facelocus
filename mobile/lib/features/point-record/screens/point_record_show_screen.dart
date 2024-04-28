import 'package:facelocus/features/point-record/blocs/point-record-show/point_record_show_bloc.dart';
import 'package:facelocus/features/point-record/widgets/event_header.dart';
import 'package:facelocus/features/point-record/widgets/point_validate.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PointRecordShowScreen extends StatefulWidget {
  const PointRecordShowScreen({super.key, required this.pointRecordId});

  final int pointRecordId;

  @override
  State<PointRecordShowScreen> createState() => _PointRecordShowScreenState();
}

class _PointRecordShowScreenState extends State<PointRecordShowScreen> {
  @override
  void initState() {
    context
        .read<PointRecordShowBloc>()
        .add(LoadPointRecord(pointRecordId: widget.pointRecordId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBarTitle: 'Registro de ponto',
      showBottomNavigationBar: false,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<PointRecordShowBloc>().add(
                LoadPointRecord(pointRecordId: widget.pointRecordId),
              );
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(29.0),
                child: BlocConsumer<PointRecordShowBloc, PointRecordShowState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is PointRecordShowLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Builder(
                            builder: (context) {
                              var pr = state.pointRecord;
                              return EventHeader(
                                description: pr.event!.description!,
                                date: pr.date,
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                          Builder(
                            builder: (context) {
                              if (state.userAttendance == null) {
                                return const Center(
                                  child: Text('Ainda não há nenhum ponto'),
                                );
                              }

                              var ars =
                                  state.userAttendance?.attendanceRecords!;
                              return ListView.separated(
                                separatorBuilder: (
                                  BuildContext context,
                                  int index,
                                ) {
                                  return const SizedBox(height: 10);
                                },
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: ars!.length,
                                itemBuilder: (context, index) {
                                  return PointValidate(
                                    pointRecord: state.pointRecord,
                                    attendanceRecord: ars[index],
                                  );
                                },
                              );
                            },
                          )
                        ],
                      );
                    }
                    return const Center(child: Spinner());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
