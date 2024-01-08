import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/shared/message_snacks.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationForm extends StatefulWidget {
  const LocationForm(
      {super.key,
      required this.formKey,
      required this.eventId,
      required this.location,
      required this.child});

  final GlobalKey<FormState> formKey;
  final LocationModel location;
  final int eventId;
  final Widget child;

  @override
  State<LocationForm> createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Descrição', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10.0),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(10.0),
              )),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Informe a descrição';
            }
            return null;
          },
          onSaved: (value) => widget.location.description = value!,
        ),
        const SizedBox(height: 15),
        TextButton.icon(
            onPressed: () => _savePosition(),
            label: const Text(
              'Pegar localização',
              style: TextStyle(color: Colors.white),
            ),
            icon: isLoading
                ? const SizedBox(width: 17, height: 17, child: CircularProgressIndicator(color: Colors.white))
                : const Icon(Icons.location_on_rounded, color: Colors.white),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.green))),
        const SizedBox(height: 10),
        Builder(
          builder: (context) {
            if (widget.location.latitude != 0.0 &&
                widget.location.longitude != 0.0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Latitudade e Longitude',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 5),
                      Text(widget.location.latitude.toString()),
                      const SizedBox(width: 10),
                      Text(widget.location.longitude.toString()),
                    ],
                  ),
                  widget.child
                ],
              );
            }
            return const Center();
          },
        )
      ]),
    );
  }

  void _savePosition() async {
    setState(() {
      isLoading = true;
    });
    try {
      Position position = await _determinePosition();
      setState(() {
        widget.location.latitude = position.latitude;
        widget.location.longitude = position.longitude;
      });
    } on Exception catch (e) {
      MessageSnacks.danger(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Os serviços de localização estão desativados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('As permissões de localização foram negadas');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'As permissões de localização foram negadas permanentemente, não é possivel solicitar permissões.');
    }
    return await Geolocator.getCurrentPosition();
  }
}
