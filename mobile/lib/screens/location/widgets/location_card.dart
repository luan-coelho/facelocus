import 'package:dio/dio.dart';
import 'package:facelocus/models/location.dart';
import 'package:facelocus/services/location_service.dart';
import 'package:facelocus/shared/message_snacks.dart';
import 'package:flutter/material.dart';

class LocationCard extends StatefulWidget {
  const LocationCard({super.key, required this.location});

  final Location location;

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  LocationService _locationService = LocationService();

  @override
  void initState() {
    _locationService = LocationService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deleteLocation() async {
      try {
        Navigator.pop(context, "OK");
        await _locationService.deleteById(widget.location.id!);
        MessageSnacks.success(context, "Localização deletada com sucesso");
      } on DioException catch (e) {
        MessageSnacks.danger(context, e.message!);
      }
    }

    return Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        width: 330,
        height: 45,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 1.5),
          ),
        ], borderRadius: BorderRadius.circular(8), color: Colors.white),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on_rounded, color: Colors.black),
                const SizedBox(width: 5),
                Text(widget.location.description!,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            GestureDetector(
                onTap: () => showDialog<String>(
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
                            onPressed: () => deleteLocation(),
                            child: const Text("Confirmar",
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ),
                child: const Icon(Icons.delete, color: Colors.red))
          ],
        )));
  }
}