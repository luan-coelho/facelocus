import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/shared/widgets/app_delete_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/location_controller.dart';

class LocationCard extends StatefulWidget {
  const LocationCard(
      {super.key, required this.location, required this.eventId});

  final LocationModel location;
  final int eventId;

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  late final LocationController _controller;

  @override
  void initState() {
    _controller = Get.find<LocationController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showDeleteDialog() {
      return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Você tem certeza?"),
          content: const Text(
              "Tem certeza de que deseja excluir este item? Esta ação é irreversível e os dados excluídos não poderão ser recuperados."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, "Cancel"),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () =>
                  _controller.deleteById(widget.location.id!, widget.eventId),
              child:
                  const Text("Confirmar", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }

    return Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        width: double.infinity,
        height: 45,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on_rounded, color: Colors.black),
                const SizedBox(width: 5),
                Text(widget.location.description,
                    style: const TextStyle(fontWeight: FontWeight.w300)),
              ],
            ),
            AppDeleteButton(onPressed: showDeleteDialog)
          ],
        )));
  }
}
