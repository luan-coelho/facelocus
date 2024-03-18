import 'package:facelocus/models/attendance_record_model.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/material.dart';

class ValidateFactors extends StatefulWidget {
  const ValidateFactors({
    super.key,
    required this.attendanceRecordId,
    required this.faceRecognitionFactor,
    required this.locationIndoorFactor,
  });

  final int attendanceRecordId;
  final bool faceRecognitionFactor;
  final bool locationIndoorFactor;

  @override
  State<ValidateFactors> createState() => _ValidateFactorsState();
}

class _ValidateFactorsState extends State<ValidateFactors> {
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBarTitle: 'Validar Fatores',
      showBottomNavigationBar: false,
      body: Column(
        children: [
          const Text('Fatores'),
          Text(
            'faceRecognitionFactor ${widget.faceRecognitionFactor.toString()}',
          ),
          Text(
            'locationIndoorFactor ${widget.locationIndoorFactor.toString()}',
          ),
        ],
      ),
    );
  }
}
