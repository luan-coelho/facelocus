import 'package:flutter/material.dart';
import 'package:mobile/services/event_service.dart';
import 'package:mobile/widgets/event/event_card.dart';

class EventCreateScreen extends StatefulWidget {
  const EventCreateScreen({super.key});

  @override
  State<EventCreateScreen> createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {
  List<EventCard> events = [];
  late EventService _eventService;
  bool isSwitched = false;

  @override
  void initState() {
    _eventService = EventService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastrar evento")),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20, right: 30, left: 30, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Descrição",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextButton.icon(
                onPressed: () => getDeviceLocation(),
                label: const Text(
                  "Localizações",
                  style: TextStyle(color: Colors.black),
                ),
                icon:
                    const Icon(Icons.location_on_rounded, color: Colors.black),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFFAB411)))),
            const SizedBox(height: 15),
            Row(
              children: [
                const Flexible(
                  child: Text(
                      "Permitir que outros participantes enviem solicitações para ingresso",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
                Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    }),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity, // Largura 100%
              height: 50,
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF003C84)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                onPressed: () => {},
                child: const Text("Cadastrar",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getDeviceLocation() {}
}
