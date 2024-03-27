import 'package:facelocus/controllers/point_record_show_controller.dart';
import 'package:facelocus/models/factor_enum.dart';
import 'package:facelocus/router.dart';
import 'package:facelocus/screens/point-record/widgets/factor_validate_card.dart';
import 'package:facelocus/shared/widgets/app_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ValidateFactorsScreen extends StatefulWidget {
  const ValidateFactorsScreen({
    super.key,
    required this.attendanceRecordId,
    required this.faceRecognitionFactor,
    required this.locationIndoorFactor,
  });

  final int attendanceRecordId;
  final bool faceRecognitionFactor;
  final bool locationIndoorFactor;

  @override
  State<ValidateFactorsScreen> createState() => _ValidateFactorsScreenState();
}

class _ValidateFactorsScreenState extends State<ValidateFactorsScreen> {
  late final PointRecordShowController _controller;

  @override
  void initState() {
    _controller = Get.find<PointRecordShowController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appBarTitle: 'Validar Fatores',
      showBottomNavigationBar: false,
      body: Padding(
        padding: const EdgeInsets.all(29.0),
        child: Column(
          children: [
            if (widget.faceRecognitionFactor) ...[
              GestureDetector(
                onTap: () => context.push(
                  '${AppRoutes.facialFactorValidate}/${widget.attendanceRecordId}',
                ),
                child: FactorValidateCard(
                    factor: Factor.facialRecognition,
                    userAttendance: _controller.userAttendance.value!),
              )
            ]
          ],
        ),
      ),
    );
  }
}
