import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/providers/location_provider.dart';
import 'package:facelocus/screens/location/widgets/location_form.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/message_snacks.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LocationCreateScreen extends StatefulWidget {
  const LocationCreateScreen({super.key, required this.eventId});

  final int eventId;

  @override
  State<LocationCreateScreen> createState() => _LocationCreateScreenState();
}

class _LocationCreateScreenState extends State<LocationCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  late LocationProvider _locationProvider;
  late LocationModel location;

  @override
  void initState() {
    _locationProvider = Provider.of<LocationProvider>(context, listen: false);
    location = LocationModel(description: '', latitude: 0.0, longitude: 0.0);
    super.initState();
  }

  void addLocation() {
    if (_formKey.currentState!.validate()) {
      if (location.latitude == 0.0 && location.longitude == 0.0) {
        MessageSnacks.warn(context, 'Sem localização definida');
        return;
      }

      _formKey.currentState!.save();
      _locationProvider.create(location, widget.eventId);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Localização")),
        body: Padding(
            padding: const EdgeInsets.all(29.0),
            child: LocationForm(
              formKey: _formKey,
              eventId: widget.eventId,
              location: location,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColorsConst.blue),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                      onPressed: () => addLocation(),
                      child: const Text("Adicionar",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  )
                ],
              ),
            )));
  }
}
