import 'package:dio/dio.dart';
import 'package:facelocus/providers/event_provider.dart';
import 'package:facelocus/router.dart';
import 'package:flutter/material.dart';
import 'package:facelocus/shared/message_snacks.dart';
import 'package:facelocus/models/event.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EventCreateScreen extends StatefulWidget {
  const EventCreateScreen({super.key});

  @override
  State<EventCreateScreen> createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {
  final Dio _dio = Dio();
  final String _baseUrl = "http://10.0.2.2:8080";
  final _formKey = GlobalKey<FormState>();
  Event event = Event.empty();
  bool allowTicketRequests = false;
  bool onSubmit = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      event.allowTicketRequests = allowTicketRequests;
      await create(event);
    }
  }

  Future<void> create(Event event) async {
    try {
      var json = event.toJson();
      await _dio.post('$_baseUrl/event', data: json);
      MessageSnacks.success(context, "Evento cadastrado com sucesso");
    } catch (e) {
      MessageSnacks.danger(context, "Falha ao criar evento");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastrar evento")),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20, right: 30, left: 30, bottom: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    return "Por favor, informe a descrição";
                  }
                  return null;
                },
                onSaved: (value) => event.description = value!,
              ),
              const SizedBox(height: 15),
              Consumer<EventProvider>(builder: (context, provider, child) {
                return TextButton.icon(
                    onPressed: () {
                      provider.change(event);
                      context.push(AppRoutes.eventLocations);
                    },
                    label: const Text(
                      "Localizações",
                      style: TextStyle(color: Colors.black),
                    ),
                    icon: const Icon(Icons.location_on_rounded,
                        color: Colors.black),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFFAB411))));
              }),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Flexible(
                    child: Text(
                        "Permitir que outros participantes enviem solicitações para ingresso",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  Switch(
                      value: allowTicketRequests,
                      onChanged: (value) {
                        setState(() {
                          allowTicketRequests = value;
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
                  onPressed: () => onSubmit ? null : _submitForm(),
                  child: const Text("Cadastrar",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getDeviceLocation() {}
}
