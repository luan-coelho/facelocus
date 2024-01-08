import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/providers/location_provider.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/screens/location/widgets/location_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LocationListScreen extends StatefulWidget {
  const LocationListScreen({super.key, required this.eventId});

  final int eventId;

  @override
  State<LocationListScreen> createState() => _LocationListScreenState();
}

class _LocationListScreenState extends State<LocationListScreen> {
  late LocationProvider _locationProvider;

  @override
  void initState() {
    _locationProvider = Provider.of<LocationProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _locationProvider.fetchAllByEventId(widget.eventId);
      _locationProvider.eventId = widget.eventId;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Localizações")),
      body: Consumer<LocationProvider>(builder: (context, state, child) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.locations.isEmpty) {
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
              itemCount: state.locations.length,
              itemBuilder: (context, index) {
                LocationModel location = state.locations[index];
                return LocationCard(location: location);
              },
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(Uri(
            path: AppRoutes.eventLocationsForm,
            queryParameters: {'event': widget.eventId.toString()}).toString()),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white, size: 29),
      ),
    );
  }
}
