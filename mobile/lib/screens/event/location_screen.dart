import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/providers/location_provider.dart';
import 'package:facelocus/screens/event/widgets/location_card.dart';
import 'package:facelocus/shared/message_snacks.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LocationListScreen extends StatefulWidget {
  const LocationListScreen({super.key, required this.eventId});

  final int eventId;

  @override
  State<LocationListScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationListScreen> {
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

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
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
      appBarTitle: 'Localizações vinculadas',
      body: Consumer<LocationProvider>(builder: (context, state, child) {
        bool showPosition =
            _location.latitude != 0.0 && _location.longitude != 0.0;
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
                        AppTextField(
                            labelText: 'Descrição',
                            textEditingController: _descriptionController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Informe a descrição';
                              }
                              return null;
                            },
                            onSaved: (value) => _location.description = value),
                        const SizedBox(height: 10),
                        AppButton(
                            text: 'Pegar localização',
                            onPressed: () => _savePosition(),
                            icon: isLoading
                                ? const SizedBox(
                                    width: 17,
                                    height: 17,
                                    child: CircularProgressIndicator(
                                        color: Colors.white))
                                : SvgPicture.asset(
                                    'images/location-icon.svg',
                                    width: 25,
                                    colorFilter: const ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                  ),
                            backgroundColor: Colors.green.shade600),
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
                        showPosition
                            ? AppButton(
                                text: 'Adicionar',
                                onPressed: () => addLocation())
                            : const SizedBox()
                      ]),
                ),
                SizedBox(height: showPosition ? 15 : 0),
                Builder(builder: (context) {
                  if (state.locations.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Ainda não há nenhuma localização',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    );
                  }
                  return Skeletonizer(
                    enabled: state.isLoading,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Locais',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 5),
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
                    ),
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
