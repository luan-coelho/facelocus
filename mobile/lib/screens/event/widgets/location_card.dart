import 'package:dio/dio.dart';
import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/providers/location_provider.dart';
import 'package:facelocus/shared/toast.dart';
import 'package:facelocus/shared/widgets/app_delete_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationCard extends StatefulWidget {
  const LocationCard({super.key, required this.location});

  final LocationModel location;

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  late LocationProvider _locationProvider;

  @override
  void initState() {
    _locationProvider = Provider.of<LocationProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deleteLocation() {
      try {
        Navigator.pop(context, "OK");
        _locationProvider.deleteById(
            widget.location.id!, _locationProvider.eventId);
        Toast.success(context, "Localização deletada com sucesso");
      } on DioException catch (e) {
        Toast.danger(context, e.message!);
      }
    }

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
              onPressed: () => deleteLocation(),
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
