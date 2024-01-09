import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/providers/location_provider.dart';
import 'package:facelocus/screens/location/widgets/location_card.dart';
import 'package:facelocus/shared/constants.dart';
import 'package:facelocus/shared/message_snacks.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class LocationListScreen extends StatefulWidget {
  const LocationListScreen({super.key, required this.eventId});

  final int eventId;

  @override
  State<LocationListScreen> createState() => _LocationListScreenState();
}

class _LocationListScreenState extends State<LocationListScreen> {
  final _formKey = GlobalKey<FormState>();
  late LocationProvider _locationProvider;
  late LocationModel _location;
  late TextEditingController _descriptionController;
  bool isLoading = false;

  @override
  void initState() {
    _locationProvider = Provider.of<LocationProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _locationProvider.fetchAllByEventId(widget.eventId);
      _locationProvider.eventId = widget.eventId;
    });
    _location = newLocationInstace();
    _descriptionController = TextEditingController();
    super.initState();
  }

  LocationModel newLocationInstace() =>
      LocationModel(description: '', latitude: 0.0, longitude: 0.0);

  void addLocation() {
    if (_formKey.currentState!.validate()) {
      if (_location.latitude == 0.0 && _location.longitude == 0.0) {
        MessageSnacks.warn(context, 'Sem localização definida');
        return;
      }

      _formKey.currentState!.save();
      _locationProvider.create(_location, widget.eventId);

      setState(() {
        _descriptionController.clear();
        _location = newLocationInstace();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBarTitle: 'Localizações',
      body: Consumer<LocationProvider>(builder: (context, state, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(29.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Descrição',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 2),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe a descrição';
                            }
                            return null;
                          },
                          onSaved: (value) => _location.description = value!,
                        ),
                        const SizedBox(height: 15),
                        TextButton.icon(
                            onPressed: () => _savePosition(),
                            label: const Text(
                              'Pegar localização',
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: isLoading
                                ? const SizedBox(
                                    width: 17,
                                    height: 17,
                                    child: CircularProgressIndicator(
                                        color: Colors.white))
                                : const Icon(Icons.location_on_rounded,
                                    color: Colors.white),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green))),
                        const SizedBox(height: 10),
                        Builder(
                          builder: (context) {
                            if (_location.latitude != 0.0 &&
                                _location.longitude != 0.0) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Latitudade e Longitude',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 5),
                                      Text(_location.latitude.toString()),
                                      const SizedBox(width: 10),
                                      Text(_location.longitude.toString()),
                                    ],
                                  ),
                                ],
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                        const SizedBox(height: 5),
                        _location.latitude != 0.0 && _location.longitude != 0.0
                            ? SizedBox(
                                width: double.infinity,
                                height: 45,
                                child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              AppColorsConst.blue),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ))),
                                  onPressed: () => addLocation(),
                                  child: const Text('Adicionar',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                ),
                              )
                            : const SizedBox()
                      ]),
                ),
                const SizedBox(height: 15),
                Builder(builder: (context) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.locations.isEmpty) {
                    return const Center(
                      child: Text(
                        'Ainda não há nenhuma localização',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Localizações cadastradas',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10),
                      ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 20);
                        },
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: state.locations.length,
                        itemBuilder: (context, index) {
                          LocationModel location = state.locations[index];
                          return LocationCard(location: location);
                        },
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _savePosition() async {
    setState(() {
      isLoading = true;
    });
    try {
      Position position = await _determinePosition();
      setState(() {
        _location.latitude = position.latitude;
        _location.longitude = position.longitude;
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
