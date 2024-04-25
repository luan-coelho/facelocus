import 'package:facelocus/features/event/blocs/event-show/event_show_bloc.dart';
import 'package:facelocus/features/event/widgets/event_code_card.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/feature_card.dart';
import 'package:facelocus/utils/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventShowScreen extends StatefulWidget {
  const EventShowScreen({super.key, required this.eventId});

  final int eventId;

  @override
  State<EventShowScreen> createState() => _EventShowScreenState();
}

class _EventShowScreenState extends State<EventShowScreen> {
  @override
  void initState() {
    context.read<EventShowBloc>().add(EventShowInitialEvent(widget.eventId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventShowBloc, EventShowState>(
      listener: (context, state) {
        if (state is ChangeTicketRequestPermissionError) {
          return Toast.showError(state.message, context);
        }
      },
      builder: (context, state) {
        return AppLayout(
          appBarTitle:
              state is EventLoaded ? state.event.description : 'Evento',
          body: Padding(
            padding: const EdgeInsets.all(29),
            child: Builder(
              builder: (context) {
                if (state is EventLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FeatureCard(
                            description: 'Usuários',
                            route: Uri(
                              path: AppRoutes.eventUsers,
                              queryParameters: {
                                'event': widget.eventId.toString()
                              },
                            ).toString(),
                            color: Colors.black,
                            backgroundColor: Colors.white,
                            imageName: 'users-icon.svg',
                            height: 100,
                          ),
                          const SizedBox(width: 15),
                          FeatureCard(
                            description: 'Localizações',
                            route: Uri(
                              path: AppRoutes.eventLocations,
                              queryParameters: {
                                'event': widget.eventId.toString()
                              },
                            ).toString(),
                            color: Colors.white,
                            backgroundColor: AppColorsConst.purple,
                            imageName: 'locations-icon.svg',
                            height: 100,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            child: Text(
                              'Permitir solicitações de ingresso',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Switch(
                            value: state.event.allowTicketRequests!,
                            onChanged: (_) => context.read<EventShowBloc>().add(
                                  ChangeTicketRequestPermission(
                                    widget.eventId,
                                  ),
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (state.event.allowTicketRequests!) ...[
                        EventCodeCard(event: state.event),
                        const SizedBox()
                      ]
                    ],
                  );
                }

                if (state is EventShowError) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                return const Center(
                  child: Spinner(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
