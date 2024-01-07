import 'package:facelocus/models/location.dart';
import 'package:facelocus/services/location_service.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/message_snacks.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

class LocationFormScreen extends StatefulWidget {
  const LocationFormScreen({super.key, required this.eventId});

  final int eventId;

  @override
  State<LocationFormScreen> createState() => _LocationFormScreenState();
}

class _LocationFormScreenState extends State<LocationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  LocationService _locationService = LocationService();
  late TextEditingController _descriptionController;
  final Location _location = Location.empty();
  bool _showPosition = false;

  @override
  void initState() {
    _locationService = LocationService();
    _descriptionController = TextEditingController();
    super.initState();
    if (_location.id != null) {
      _showPosition = true;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void addLocation() {
    if (_formKey.currentState!.validate()) {
      if (_location.longitude == null && _location.longitude == null) {
        MessageSnacks.warn(context, "Sem localização definida");
        return;
      }

      _formKey.currentState!.save();
      _locationService.create(context, _location, widget.eventId);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Localização")),
      body: Padding(
          padding: const EdgeInsets.all(29.0),
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Descrição",
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Informe a descrição";
                  }
                  return null;
                },
                onSaved: (value) => _location.description = value!,
              ),
              const SizedBox(height: 15),
              TextButton.icon(
                  onPressed: () => _determinePosition(),
                  label: const Text(
                    "Pegar localização",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(Icons.location_on_rounded,
                      color: Colors.white),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green))),
              const SizedBox(height: 10),
              Builder(
                builder: (context) {
                  if (_showPosition) {
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_searching),
                            const SizedBox(width: 5),
                            const Text(
                              "Latitudade",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 5),
                            Text(_location.latitude.toString()),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_searching),
                            const SizedBox(width: 5),
                            const Text("Longitude",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            const SizedBox(width: 5),
                            Text(_location.longitude.toString()),
                          ],
                        ),
                      ],
                    );
                  }
                  return const Center();
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(AppConst.blue),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ))),
                  onPressed: () => addLocation(),
                  child: const Text("Adicionar",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              )
            ]),
          )),
    );
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition();
    _location.latitude = position.latitude;
    _location.longitude = position.longitude;
    setState(() {
      _showPosition = true;
    });
  }
}
