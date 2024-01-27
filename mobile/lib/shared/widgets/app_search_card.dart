import 'package:flutter/material.dart';

class AppSearchCard extends StatefulWidget {
  const AppSearchCard({super.key, required this.description});

  final String description;

  @override
  State<AppSearchCard> createState() => _AppSearchCardState();
}

class _AppSearchCardState<T> extends State<AppSearchCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        width: double.infinity,
        height: 45,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(widget.description,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis)),
            ),
          ],
        ));
  }
}
