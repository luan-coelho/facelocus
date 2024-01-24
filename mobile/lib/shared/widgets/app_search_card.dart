import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppSearchCard<T> extends StatefulWidget {
  const AppSearchCard(
      {super.key,
      this.fuction,
      required this.callback,
      required this.description,
      required this.entity});

  final void Function()? fuction;
  final Function(T) callback;
  final String description;
  final T entity;

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
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 5,
                offset: const Offset(0, 1.5),
              ),
            ],
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
            SizedBox(
              height: 30.0,
              width: 30.0,
              child: IconButton(
                padding: const EdgeInsets.all(0.0),
                onPressed: () {
                  widget.callback(widget.entity);
                  context.pop();
                },
                icon: const Icon(Icons.check, size: 18.0),
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
              ),
            ),
          ],
        ));
  }
}
