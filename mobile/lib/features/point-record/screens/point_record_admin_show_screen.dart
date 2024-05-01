import 'package:facelocus/features/event/delegates/lincked_users_delegate.dart';
import 'package:facelocus/features/point-record/blocs/point-record-admin-show/point_record_admin_show_bloc.dart';
import 'package:facelocus/features/point-record/widgets/event_header.dart';
import 'package:facelocus/features/point-record/widgets/user_attedance_validate_card.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/empty_data.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PointRecordAdminShowScreen extends StatefulWidget {
  const PointRecordAdminShowScreen({
    super.key,
    required this.pointRecordId,
  });

  final int pointRecordId;

  @override
  State<PointRecordAdminShowScreen> createState() =>
      _PointRecordAdminShowScreenState();
}

class _PointRecordAdminShowScreenState
    extends State<PointRecordAdminShowScreen> {
  @override
  void initState() {
    context.read<PointRecordAdminShowBloc>().add(
          LoadPointRecordAdminShow(pointRecordId: widget.pointRecordId),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBarTitle: 'Registro de ponto',
      actions: [
        IconButton(
          icon: const Icon(
            Icons.edit,
            color: Colors.white,
          ),
          onPressed: () => context.push(
            '/admin${AppRoutes.pointRecordEdit}/${widget.pointRecordId}',
          ),
        )
      ],
      showBottomNavigationBar: false,
      body: Padding(
        padding: const EdgeInsets.all(29.0),
        child: BlocBuilder<PointRecordAdminShowBloc, PointRecordAdminShowState>(
          builder: (context, state) {
            if (state is PointRecordAdminShowLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EventHeader(
                    description: state.pointRecord.event!.description ?? '...',
                    date: state.pointRecord.date,
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Builder(
                          builder: (context) {
                            return ListView.separated(
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(height: 10);
                              },
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: state.userAttendances.length,
                              itemBuilder: (context, index) {
                                return UserAttendanceValidateCard(
                                  userAttendance: state.userAttendances[index],
                                  pointRecordId: widget.pointRecordId,
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              );
            }

            if (state is NoLinckedUsers) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const EmptyData('Sem usuários vinculados ao evento'),
                  const SizedBox(height: 15),
                  AppButton(
                    text: 'Enviar solicitação',
                    onPressed: () async {
                      await showSearch(
                        context: context,
                        delegate: LinckedUsersDelegate(
                          eventId: state.pointRecordId,
                        ),
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
    );
  }
}
