import 'dart:async';

import 'package:flutter/material.dart';

class AppSearchField extends StatefulWidget {
  const AppSearchField(
      {super.key,
      required this.itens,
      this.child,
      required this.function,
      required this.isLoading});

  final List itens;
  final Widget? child;
  final Function function;
  final bool isLoading;

  @override
  AppSearchFieldState createState() => AppSearchFieldState();
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

class AppSearchFieldState extends State<AppSearchField> {
  final _debouncer = Debouncer();
  late TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
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
              suffixIcon: InkWell(
                child: widget.isLoading
                    ? const Icon(Icons.search)
                    : const SizedBox(
                        width: 17,
                        height: 17,
                        child: CircularProgressIndicator(color: Colors.white)),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              hintText: 'Pesquisar',
            ),
            onChanged: (string) {
              _debouncer.run(() {
                widget.function();
              });
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(5),
            itemCount: widget.itens.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: widget.child,
              );
            },
          ),
        ],
      ),
    );
  }
}
