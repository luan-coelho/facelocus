import 'package:flutter/material.dart';

class AppSearchCard<T> extends StatefulWidget {
  const AppSearchCard({
    super.key,
    required this.description,
    this.child,
  });

  final String description;
  final Widget? child;

  @override
  State<AppSearchCard<T>> createState() => _AppSearchCardState<T>();
}

class _AppSearchCardState<T> extends State<AppSearchCard<T>> {
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
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis)),
            ),
            widget.child ?? const SizedBox()
          ],
        ));
  }
}
