import 'package:facelocus/controllers/event_controller.dart';
import 'package:facelocus/controllers/point_record_controller.dart';
import 'package:facelocus/models/event_model.dart';
import 'package:facelocus/screens/event/widgets/users_search.dart';
import 'package:facelocus/shared/widgets/app_search_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventSearch extends StatefulWidget {
  const EventSearch({super.key});

  @override
  State<EventSearch> createState() => _EventSearchState();
}

class _EventSearchState extends State<EventSearch> {
  final _debouncer = Debouncer();
  late final EventController _controller;
  late final PointRecordController _pointRecordController;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<EventController>();
    _pointRecordController = Get.find<PointRecordController>();
  }

  //Main Widget
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(10.0),
      scrollable: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            TextField(
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  hintText: 'Descrição',
                  hintStyle: const TextStyle(fontSize: 14),
                  counter: const Offstage(),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: const InkWell(
                    child: Icon(Icons.search),
                  )),
              onChanged: (value) {
                _debouncer.run(() {
                  _controller.fetchAllByDescription(context, value);
                });
              },
            ),
            Builder(builder: (context) {
              double height = MediaQuery.of(context).size.height;
              height = height - (height * 0.7);
              return SizedBox(
                height: height,
                child: Obx(() {
                  return SingleChildScrollView(
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 10);
                      },
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _controller.events.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AppSearchCard<EventModel>(
                            callback: (value) {
                              setState(() {
                                _pointRecordController.event.value = value;
                              });
                            },
                            entity: _controller.events[index],
                            description:
                                _controller.events[index].description!);
                      },
                    ),
                  );
                }),
              );
            }),
          ],
        ),
      ),
    );
  }
}
