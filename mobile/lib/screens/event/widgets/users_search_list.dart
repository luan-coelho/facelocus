import 'package:facelocus/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UsersSearchList extends StatefulWidget {
  const UsersSearchList({
    super.key,
  });

  @override
  UsersSearchListState createState() => UsersSearchListState();
}

class UsersSearchListState extends State<UsersSearchList> {
  late final UserController _controller;

  @override
  void initState() {
    _controller = Get.find<UserController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Skeletonizer(
          enabled: _controller.isLoading.value,
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(5),
            itemCount: _controller.usersSearch.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          _controller.usersSearch[index].name,
                          style: const TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          _controller.usersSearch[index].cpf,
                          style: const TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
