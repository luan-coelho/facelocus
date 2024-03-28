import 'package:facelocus/controllers/point_record_show_controller.dart';
import 'package:facelocus/controllers/validate_point_controller.dart';
import 'package:facelocus/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ILFactorValidateScreen extends StatefulWidget {
  const ILFactorValidateScreen({
    super.key,
    required this.attendanceRecordId,
  });

  final int attendanceRecordId;

  @override
  State<ILFactorValidateScreen> createState() => _ILFactorValidateScreenState();
}

class _ILFactorValidateScreenState extends State<ILFactorValidateScreen> {
  late final ValidatePointController _validatePointController;
  late final PointRecordShowController _pointRecordController;

  @override
  void initState() {
    _validatePointController = Get.find<ValidatePointController>();
    _pointRecordController = Get.find<PointRecordShowController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void getDeviceInfo() async {
      String? identifier = await _validatePointController.getDeviceIdentifier();
      debugPrint(identifier);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(
            Icons.close,
            color: Colors.black,
            size: 30,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(29.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppButton(
              text: 'Pegar Id',
              onPressed: getDeviceInfo,
            ),
            const Center(child: Text('Validar fator')),
          ],
        ),
      ),
    );
  }
}
