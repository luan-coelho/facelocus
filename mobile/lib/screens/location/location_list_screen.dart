import 'package:facelocus/models/location.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/screens/location/widgets/location_card.dart';
import 'package:facelocus/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LocationListScreen extends StatefulWidget {
  const LocationListScreen({super.key, required this.eventId});

  final int eventId;

  @override
  State<LocationListScreen> createState() => _LocationListScreenState();
}

class _LocationListScreenState extends State<LocationListScreen> {
  @override
  void initState() {
    super.initState();
    _locationService = LocationService();
    _futureLocations =
        _locationService.getAllByEventId(context, widget.eventId);
  }

  late LocationService _locationService;
  late Future<List<Location>> _futureLocations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Localizações")),
      body: FutureBuilder<List<Location>>(
          future: _futureLocations,
          builder:
              (BuildContext context, AsyncSnapshot<List<Location>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Erro ao buscar dados'));
            } else {
              List<Location> locations = snapshot.data!;

              if (locations.isEmpty) {
                return const Center(
                  child: Text(
                    "Ainda não há nenhuma localização",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                );
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: ListView.separated(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 20);
                    },
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: locations.length,
                    itemBuilder: (context, index) {
                      Location location = locations[index];
                      return LocationCard(location: location);
                    },
                  ),
                ),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.eventLocationsForm),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white, size: 29),
      ),
    );
  }
}
