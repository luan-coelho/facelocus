import 'package:facelocus/models/location_model.dart';
import 'package:facelocus/screens/event/widgets/location_card.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:facelocus/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../controllers/location_controller.dart';

class LocationListScreen extends StatefulWidget {
  const LocationListScreen({super.key, required this.eventId});

  final int eventId;

  @override
  State<LocationListScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationListScreen> {
  late final LocationController _controller;
  final _formKey = GlobalKey<FormState>();
  late LocationModel _location;
  late TextEditingController _descriptionController;
  bool isLoading = false;

  @override
  void initState() {
    _controller = Get.find<LocationController>();
    _controller.newLocationInstace();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchAllByEventId(widget.eventId);
    });
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void addLocation() {
    if (_formKey.currentState!.validate()) {
      _controller.location.value!.description = _descriptionController.text;
      _controller.create(_controller.location.value!, widget.eventId);
      setState(() {
        _descriptionController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBarTitle: 'Localizações vinculadas',
      body: Obx(() {
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
                        const SizedBox(height: 5),
                        AppButton(
                            text: 'Pegar localização',
                            onPressed: () => _controller.savePosition(context),
                            icon: _controller.isLoading.value
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
                            if (_controller.showPosition.value) {
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
                                      Text(_controller.location.value!.latitude
                                          .toString()),
                                      const SizedBox(width: 10),
                                      Text(_controller.location.value!.latitude
                                          .toString()),
                                    ],
                                  ),
                                ],
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                        const SizedBox(height: 5),
                        _controller.showPosition.value
                            ? AppButton(
                                text: 'Adicionar', onPressed: addLocation)
                            : const SizedBox()
                      ]),
                ),
                SizedBox(height: _controller.showPosition.value ? 15 : 0),
                Builder(builder: (context) {
                  if (_controller.locations.isEmpty) {
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
                    enabled: _controller.isLoading.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Locais',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 5),
                        ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 10);
                          },
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _controller.locations.length,
                          itemBuilder: (context, index) {
                            var location = _controller.locations[index];
                            return LocationCard(
                                location: location, eventId: widget.eventId);
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
}
