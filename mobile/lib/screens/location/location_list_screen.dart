import 'package:facelocus/models/location.dart';
import 'package:facelocus/providers/event_provider.dart';
import 'package:facelocus/screens/location/widgets/location_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LocationListScreen extends StatefulWidget {
  const LocationListScreen({super.key});

  @override
  State<LocationListScreen> createState() => _LocationListScreenState();
}

class _LocationListScreenState extends State<LocationListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Localizações")),
      body: Consumer<EventProvider>(builder: (context, storedValue, child) {
        if (storedValue.event.locations == null ||
            storedValue.event.locations!.isEmpty) {
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
              itemCount: storedValue.event.locations!.length,
              itemBuilder: (context, index) {
                Location location = storedValue.event.locations![index];
                return LocationCard(location: location);
              },
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push("/event/locations/form"),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white, size: 29),
      ),
    );
  }
}
