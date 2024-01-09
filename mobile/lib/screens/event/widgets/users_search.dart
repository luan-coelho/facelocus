import 'dart:async';

import 'package:facelocus/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersSearch extends StatefulWidget {
  const UsersSearch(this.eventId, {super.key});

  final int eventId;

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
  late UserProvider _userProvider;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, state, child) {
      return Column(
        children: [
          TextField(
            controller: _searchController,
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
              suffixIcon: const InkWell(
                child: Icon(Icons.search),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              hintText: 'Pesquisar',
            ),
            onChanged: (string) {
              _debouncer.run(() {
                _userProvider.fetchAllByNameOrCpf(_searchController.text);
              });
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(5),
            itemCount: state.users.length,
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
                          state.users[index].name,
                          style: const TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          state.users[index].cpf,
                          style: const TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      );
    });
  }
}
