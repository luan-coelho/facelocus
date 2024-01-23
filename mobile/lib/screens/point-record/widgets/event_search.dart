import 'package:facelocus/controllers/event_controller.dart';
import 'package:facelocus/screens/event/widgets/users_search.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = Get.find<EventController>();
  }

  //Main Widget
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //Search Bar to List of typed Subject
        Container(
          padding: const EdgeInsets.all(15),
          child: TextField(
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
                hintText: 'Descrição do evento',
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
        ),
        Obx(() {
          return ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: _controller.events.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          _controller.events[index].description!,
                          style: const TextStyle(fontSize: 16),
                        ),
                        subtitle: const Text('Teste'),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
