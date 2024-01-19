import 'package:facelocus/router.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PointRecordCreateScreen extends StatefulWidget {
  const PointRecordCreateScreen({super.key});

  @override
  State<PointRecordCreateScreen> createState() =>
      _PointRecordCreateScreenState();
}

class _PointRecordCreateScreenState extends State<PointRecordCreateScreen> {
  bool allowTicketRequests = false;
  double _currentSliderValue = 5.0;

  @override
  Widget build(BuildContext context) {
    return AppLayout(
        appBarTitle: 'Novo registro de ponto',
        body: Padding(
          padding: const EdgeInsets.all(29.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Fatores de validação',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Text('Reconhecimento Facial',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Text('Localização Indoor',
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
              Column(
                children: [
                  const Text('Raio permitido em metros (m)',
                      style: TextStyle(fontWeight: FontWeight.normal)),
                  Slider(
                    value: _currentSliderValue,
                    min: 0.0,
                    max: 10.0,
                    divisions: 5,
                    label: _currentSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                    },
                  )
                ],
              ),
              const SizedBox(height: 10),
              const Text('Pontos',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              AppButton(
                  text: 'Cadastrar',
                  onPressed: () =>
                      context.push(AppRoutes.pointRecordPointValidate)),
            ],
          ),
        ));
  }
}
