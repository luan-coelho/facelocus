import 'dart:async';

import 'package:facelocus/controllers/user_controller.dart';
import 'package:facelocus/screens/event/widgets/users_search_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersSearch extends StatefulWidget {
  const UsersSearch(this.eventId,
      {super.key, required this.textEditingController});

  final int eventId;
  final TextEditingController textEditingController;

  @override
  UsersSearchState createState() => UsersSearchState();
}

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      const Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}

class UsersSearchState extends State<UsersSearch> {
  final _debouncer = Debouncer();
  late final UserController _controller;

  @override
  void initState() {
    _controller = Get.find<UserController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    runSearch() {
      _debouncer.run(() {
        _controller.fetchAllByNameOrCpf(widget.textEditingController.text);
      });
    }

    return SingleChildScrollView(
        child: Column(
      children: [
        TextField(
          controller: widget.textEditingController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
            ),
            /*suffixIcon: _controller.isLoading.value
                ? const UnconstrainedBox(
                    child: SizedBox(
                        width: 17,
                        height: 17,
                        child: CircularProgressIndicator(color: Colors.black)),
                  )
                : const Icon(Icons.search),*/
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            hintText: 'Pesquisar',
          ),
          onChanged: (_) => runSearch(),
        ),
        const UsersSearchList()
      ],
    ));
  }
}
