import 'package:facelocus/controllers/event_controller.dart';
import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/screens/event/event_create_form.dart';
import 'package:facelocus/screens/event/widgets/event_card.dart';
import 'package:facelocus/screens/event/widgets/event_request_create_form.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  late EventController _controller;

  @override
  void initState() {
    _controller = Get.find<EventController>();
    _controller.fetchAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showEventCreateForm() {
      showModalBottomSheet<void>(
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: const EventCreateForm(),
          );
        },
      );
    }

    showEventRequestCreateForm() {
      showModalBottomSheet<void>(
        isScrollControlled: true,
        isDismissible: true,
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: const EventRequestCreateForm(),
          );
        },
      );
    }

    return AppLayout(
      appBarTitle: 'Eventos',
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: AppButton(
                  onPressed: showEventRequestCreateForm,
                  textColor: Colors.black,
                  backgroundColor: Colors.white,
                  borderColor: Colors.black.withOpacity(0.5),
                  text: 'Ingressar-se',
                )),
                const SizedBox(width: 15),
                Expanded(
                    child: AppButton(
                        onPressed: showEventCreateForm, text: 'Criar evento'))
              ],
            ),
            const SizedBox(height: 25),
            Obx(() {
              if (!_controller.isLoading.value && _controller.events.isEmpty) {
                return const EmptyData('Você ainda não criou nenhum evento');
              }
              return Skeletonizer(
                enabled: _controller.isLoading.value,
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 10);
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _controller.events.length,
                  itemBuilder: (context, index) {
                    EventModel event = _controller.events[index];
                    return EventCard(event: event);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
